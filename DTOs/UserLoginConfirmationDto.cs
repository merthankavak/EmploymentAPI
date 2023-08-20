namespace EmploymentAPI.DTOs
{
    public partial class UserLoginConfirmationDto
    {
        public byte[] PasswordHash { get; set; }
        public byte[] PasswordSalt { get; set; }

        public UserLoginConfirmationDto()
        {
            PasswordHash ??= new byte[0];
            PasswordSalt ??= new byte[0];
        }
    }
}