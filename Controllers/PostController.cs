using System.Data;
using Dapper;
using EmploymentAPI.Data;
using EmploymentAPI.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EmploymentAPI.Controllers
{
    [Authorize]
    [ApiController]
    [Route("[controller]")]
    public class PostController : ControllerBase
    {
        private readonly DataContextDapper _dapper;

        public PostController(IConfiguration config)
        {
            _dapper = new DataContextDapper(config);
        }

        [HttpGet("GetPosts/{postId}/{userId}/{searchParam}")]
        public IEnumerable<Post> GetPosts(int postId = 0, int userId = 0, string searchParam = "None")
        {
            string sql = @"EXEC EmploymentSchema.spPosts_Get";
            string strParameters = "";

            DynamicParameters sqlParameters = new DynamicParameters();

            if (postId != 0)
            {
                strParameters += ", @PostId = @PostIdParameter";
                sqlParameters.Add("@PostIdParameter", postId, DbType.Int32);
            }

            if (userId != 0)
            {
                strParameters += ", @UserId = @UserIdParameter";
                sqlParameters.Add("@UserIdParameter", userId, DbType.Int32);
            }

            if (searchParam.ToLower() != "none")
            {
                strParameters += ", @SearchParam = @SearchParamParameter";
                sqlParameters.Add("@SearchParamParameter", searchParam, DbType.String);
            }

            if (strParameters.Length > 0)
            {
                sql += strParameters.Substring(1);
            }

            return _dapper.LoadDataWithParams<Post>(sql, sqlParameters);
        }

        [HttpGet("GetMyPosts")]
        public IEnumerable<Post> GetMyPosts()
        {
            string? userIdFromToken = User.FindFirst("userId")?.Value;
            string sql = @"EXEC EmploymentSchema.spPosts_Get @UserId = @UserIdParameter";

            DynamicParameters sqlParameters = new DynamicParameters();
            sqlParameters.Add("@UserIdParameter", userIdFromToken, DbType.Int32);

            return _dapper.LoadDataWithParams<Post>(sql, sqlParameters);
        }

        [HttpPut("UpsertPost")]
        public IActionResult UpsertPost(Post post)
        {
            string sql = @"
            EXEC EmploymentSchema.spPosts_Upsert
                @UserId = @UserIdParameter, 
                @PostTitle = @PostTitleParameter, 
                @PostContent = @PostContentParameter";

            string? userIdFromToken = User.FindFirst("userId")?.Value;

            DynamicParameters sqlParameters = new DynamicParameters();
            sqlParameters.Add("@UserIdParameter", userIdFromToken, DbType.Int32);
            sqlParameters.Add("@PostTitleParameter", post.PostTitle, DbType.String);
            sqlParameters.Add("@PostContentParameter", post.PostContent, DbType.String);

            bool isUpsert = _dapper.ExecuteSqlWithParams(sql, sqlParameters);

            return isUpsert ? Ok(post) : throw new Exception("Failed to upsert post!");
        }

        [HttpDelete("DeletePost/{postId}")]
        public IActionResult DeletePost(int postId)
        {
            string sql = @"
            EXEC EmploymentSchema.spPost_Delete 
                @UserId = @UserIdParameter, 
                @PostId = @PostIdParameter";

            string? userIdFromToken = User.FindFirst("userId")?.Value;

            DynamicParameters sqlParameters = new DynamicParameters();

            sqlParameters.Add("@UserIdParameter", userIdFromToken, DbType.Int32);
            sqlParameters.Add("@PostIdParameter", postId, DbType.Int32);

            bool isDeleted = _dapper.ExecuteSqlWithParams(sql, sqlParameters);

            return isDeleted ? Ok() : throw new Exception("Failed to delete post!");
        }

    }
}