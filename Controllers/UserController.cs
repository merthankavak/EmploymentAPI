using System.Data;
using Dapper;
using EmploymentAPI.Helpers;
using EmploymentAPI.Data;
using EmploymentAPI.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EmploymentAPI.Controllers;

[Authorize]
[ApiController]
[Route("[controller]")]
public class UserController : ControllerBase
{
    private readonly DataContextDapper _dapper;
    private readonly ReusableSql _reusableSql;

    public UserController(IConfiguration config)
    {
        _dapper = new DataContextDapper(config);
        _reusableSql = new ReusableSql(config);

    }
    [HttpGet("GetUsers/{userId}/{isActive}")]
    public IEnumerable<User> GetUsers(int userId, bool isActive)
    {
        string sql = @"EXEC EmploymentSchema.spUsers_Get";
        string strParams = "";

        DynamicParameters sqlParameters = new DynamicParameters();

        if (userId != 0)
        {
            strParams += ", @UserId=@UserIdParameter";
            sqlParameters.Add("@UserIdParameter", userId, DbType.Int32);
        }

        if (isActive)
        {
            strParams += ", @Active=@ActiveParameter";
            sqlParameters.Add("@ActiveParameter", isActive, DbType.Boolean);
        }

        if (strParams.Length > 0)
        {
            sql += strParams.Substring(1);
        }
        
        return _dapper.LoadDataWithParams<User>(sql, sqlParameters);
    }

    [HttpPut("UpsertUser")]
    public IActionResult UpsertUser(User user)
    {
        bool isUpsert = _reusableSql.UpsertUser(user);

        if (isUpsert)
        {
            return Ok(user);
        }
        else
        {
            throw new Exception("Failed to upsert user!");
            
        }
    }

    [HttpDelete("DeleteUser/{userId}")]
    public IActionResult DeleteUser(int userId)
    {
        string sql = @"EXEC EmploymentSchema.spUser_Delete @UserId = @UserIdParameter";

        DynamicParameters sqlParameters = new DynamicParameters();
        sqlParameters.Add("@UserIdParameter", userId, DbType.Int32);

        bool isDeleted = _dapper.ExecuteSqlWithParams(sql, sqlParameters);

        return isDeleted ? Ok() : throw new Exception("Failed to delete user!");
    }
}
