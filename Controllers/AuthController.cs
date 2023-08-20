using System.Data;
using AutoMapper;
using Dapper;
using EmploymentAPI.Helpers;
using EmploymentAPI.Data;
using EmploymentAPI.DTOs;
using EmploymentAPI.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EmploymentAPI.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly DataContextDapper _dapper;
        private readonly AuthHelper _authHelper;
        private readonly ReusableSql _reusableSql;
        private readonly IMapper _mapper;

        public AuthController(IConfiguration config)
        {
            _dapper = new DataContextDapper(config);
            _authHelper = new AuthHelper(config);
            _reusableSql = new ReusableSql(config);
            _mapper = new Mapper(new MapperConfiguration(config =>
            {
                config.CreateMap<UserRegisterDto, User>();
            }));
        }

        [AllowAnonymous]
        [HttpPost("Register")]
        public IActionResult Register(UserRegisterDto userRegisterDto)
        {
            if (userRegisterDto.Password == userRegisterDto.PasswordConfirm)
            {
                string sqlCheckUserExists = @"SELECT * FROM EmploymentSchema.Auth WHERE Email = @EmailParameter";

                DynamicParameters sqlParameters = new DynamicParameters();
                sqlParameters.Add("@EmailParameter", userRegisterDto.Email, DbType.String);

                IEnumerable<string> existingUser = _dapper.LoadDataWithParams<string>(sqlCheckUserExists, sqlParameters);

                if (existingUser.Count() == 0)
                {
                    UserLoginDto userForSetPassword = new UserLoginDto()
                    {
                        Email = userRegisterDto.Email,
                        Password = userRegisterDto.Password
                    };
                    if (_authHelper.SetPassword(userForSetPassword))
                    {
                        User user = _mapper.Map<User>(userRegisterDto);
                        user.Active = true;

                        bool isAdded = _reusableSql.UpsertUser(user);

                        return isAdded ? Ok() : throw new Exception("Failed to add user.");
                    }
                    throw new Exception("Failed to register user.");
                }
                throw new Exception("User with this email already exists!");
            }
            throw new Exception("Passwords do not match!");
        }

        [AllowAnonymous]
        [HttpPost("Login")]
        public IActionResult Login(UserLoginDto userLoginDto)
        {
            string sql = @"
            EXEC EmploymentSchema.spLoginConfirmation_Get 
                @Email = @EmailParameter";

            DynamicParameters sqlParameters = new DynamicParameters();
            sqlParameters.Add("@EmailParameter", userLoginDto.Email, DbType.String);

            UserLoginConfirmationDto userConfirmationDto = _dapper.LoadDataSingleWithParams<UserLoginConfirmationDto>(sql, sqlParameters);

            byte[] passwordHash = _authHelper.GetPasswordHash(userLoginDto.Password, userConfirmationDto.PasswordSalt);

            for (int i = 0; i < passwordHash.Length; i++)
            {
                if (passwordHash[i] != userConfirmationDto.PasswordHash[i])
                {
                    return StatusCode(401, "Incorrect password!");
                }
            }

            string sqlForUserId = @"SELECT [UserId] FROM EmploymentSchema.Users WHERE Email = @EmailParameter";

            int userId = _dapper.LoadDataSingleWithParams<int>(sqlForUserId, sqlParameters);

            Dictionary<string, string> tokenResponse = new()
            {
                {
                    "token", _authHelper.CreateToken(userId)
                }
            };

            return Ok(tokenResponse);
        }

        [HttpPut("ResetPassword")]
        public IActionResult ResetPassword(UserLoginDto userForSetPassword)
        {
            bool isDone = _authHelper.SetPassword(userForSetPassword);

            return isDone ? Ok() : throw new Exception("Failed to update password!");
        }

        [HttpGet("RefreshToken")]
        public string RefreshToken()
        {
            string sqlForUserId = @"SELECT [UserId] FROM EmploymentSchema.Users WHERE UserId = @UserIdParameter";
            string? userIdClaim = User.FindFirst("userId")?.Value;

            DynamicParameters sqlParameters = new DynamicParameters();
            sqlParameters.Add("@UserIdParameter", userIdClaim, DbType.Int32);

            int userId = _dapper.LoadDataSingleWithParams<int>(sqlForUserId, sqlParameters);

            return _authHelper.CreateToken(userId);
        }

    }
}