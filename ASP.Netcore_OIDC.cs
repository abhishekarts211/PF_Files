Integrating an ASP.NET Core application with PingFederate using the Authorization Code Flow 

Prerequisites
PingFederate Configuration: Your PingFederate instance should be set up to support OAuth 2.0 Authorization Code Flow. You need the following:

Client ID
Client Secret
Redirect URI
Scopes like openid, profile, email, etc.
ASP.NET Core 6+ Application: We'll use the OpenID Connect middleware provided by ASP.NET Core to handle OAuth 2.0 Authorization Code Flow.



Step 1: Install Required NuGet Packages
As previously mentioned, you need to install the Microsoft.Identity.Web package in your ASP.NET Core project.

dotnet add package Microsoft.Identity.Web

Step 2: Configure OpenID Connect in Program.cs
In ASP.NET Core 6 or later, we configure authentication in Program.cs.

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

builder.Services.AddAuthentication(options =>
{
    options.DefaultScheme = "Cookies"; // Session-based authentication using cookies
    options.DefaultChallengeScheme = "OpenIDConnect"; // Will trigger authentication flow
})
.AddCookie("Cookies") // Cookie to store user session
.AddOpenIDConnect("OpenIDConnect", options =>
{
    options.Authority = "https://pingfederate.example.com"; // PingFederate Authorization Server URL
    options.ClientId = "your-client-id"; // Client ID from PingFederate
    options.ClientSecret = "your-client-secret"; // Client Secret from PingFederate
    options.ResponseType = "code"; // Authorization Code Flow
    options.Scope.Add("openid");
    options.Scope.Add("profile");
    options.Scope.Add("email");

    // Redirect URI after successful login
    options.RedirectUri = builder.Configuration["Authentication:RedirectUri"];
    
    // Post-logout redirect URI
    options.PostLogoutRedirectUri = builder.Configuration["Authentication:PostLogoutRedirectUri"];

    // Save tokens in the cookie for use later
    options.SaveTokens = true; // This ensures that the access token is saved in the cookie for subsequent use.

    // Optionally, handle token validation or error handling
    options.Events = new Microsoft.AspNetCore.Authentication.OpenIdConnect.OpenIdConnectEvents
    {
        OnTokenValidated = context =>
        {
            // You can add custom code here after token is validated
            return Task.CompletedTask;
        },
        OnAuthenticationFailed = context =>
        {
            // Optional: Handle authentication failure (log errors, etc.)
            return Task.CompletedTask;
        }
    };
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();

Key Points:

Authorization Code Flow: This is set by specifying the ResponseType = "code", meaning that after a successful login, PingFederate will send an authorization code back to your redirect URI.

Token Exchange: The token exchange process is automatically handled by the AddOpenIDConnect middleware. After receiving the authorization code from PingFederate, the middleware will automatically exchange it for the access token and ID token (if requested), as well as any other tokens (refresh tokens) depending on the configuration.

Save Tokens: The line options.SaveTokens = true ensures that the obtained access token and ID token (or other tokens) are saved in the cookie for use in subsequent requests. You don't need to manually handle the token exchange.

Step 3: Handling the Authorization Code and Token Exchange
The Authorization Code sent by PingFederate will be processed automatically by the OpenID Connect middleware. The middleware will:

Receive the authorization code from PingFederate's callback (i.e., https://localhost:5001/signin-oidc).
Exchange the authorization code for an access token (and optionally a refresh token and ID token).
Save the access token (and other tokens, such as ID token, if configured) in a secure cookie.
The token exchange process is abstracted, and no additional code is needed to manually request the tokens. The tokens are automatically available for use in your application.

Step 4: Retrieve Access Token and Use It for API Calls
Once the user is authenticated, you can retrieve the access token from the authentication context to make API calls.

Here’s an example of how to retrieve the access token and use it in API calls:

using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace YourApp.Controllers
{
    public class ApiController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;

        public ApiController(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }

        public async Task<IActionResult> GetUserProfile()
        {
            // Get the access token from the authentication context (cookie)
            var accessToken = await HttpContext.GetTokenAsync("access_token");

            if (string.IsNullOrEmpty(accessToken))
            {
                return Unauthorized();
            }

            var client = _httpClientFactory.CreateClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", accessToken);

            var response = await client.GetAsync("https://api.example.com/user-profile");

            if (response.IsSuccessStatusCode)
            {
                var profile = await response.Content.ReadAsStringAsync();
                return View("UserProfile", profile);
            }

            return View("Error");
        }
    }
}

Key Points:

HttpContext.GetTokenAsync("access_token"): This method retrieves the access token stored in the authentication context after the token exchange is complete. This is possible because Microsoft.Identity.Web saves the token in a cookie for subsequent requests.

Using the Token for API Calls: The token is then used in the Authorization header as a Bearer token for making authenticated API calls.
Recap of Token Exchange Flow

User initiates login: The user is redirected to PingFederate for authentication via the Challenge method.

Authorization Code returned: After successful authentication, PingFederate sends the authorization code to the redirect URI (configured as /signin-oidc).

Authorization Code Exchange: The OpenID Connect middleware automatically exchanges the authorization code for an access token.

Token storage: The access token (and other tokens) is saved in the cookie (because of options.SaveTokens = true).

API calls using the access token: You can retrieve the access token via HttpContext.GetTokenAsync("access_token") and use it to authenticate API requests.




