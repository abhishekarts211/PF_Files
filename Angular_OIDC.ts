Integrating an Angular App with PingFederate using Authorization Code Flow (OAuth 2.0 / OIDC)

This document will guide you through the process of integrating your Angular application with PingFederate using the OAuth 2.0 Authorization Code Flow. It will cover generating the necessary tokens, securely handling authentication, and ensuring that you can make authenticated API calls.

Pre-requisites
PingFederate Configuration: Your PingFederate instance must be configured as an OAuth 2.0 Authorization Server, and you should have the following:

Client ID and Client Secret.
Redirect URI registered in PingFederate, which will handle the callback after successful authentication.
Scopes like openid, profile, email, etc., as needed by your application.
Install angular-auth-oidc-client Library: This library helps with handling the OAuth 2.0 and OIDC flow easily.

To install it in your Angular project, run the following:
npm install angular-auth-oidc-client


Step-by-Step Guide
Step 1: Configure the OIDC Client in Angular
First, you'll need to configure the angular-auth-oidc-client library to handle the OAuth 2.0 Authorization Code Flow.

In your app.module.ts, import and configure the OIDC client:

import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { OidcSecurityService, OidcConfigService } from 'angular-auth-oidc-client';

import { AppComponent } from './app.component';

@NgModule({
  declarations: [AppComponent],
  imports: [
    BrowserModule,
    HttpClientModule
  ],
  providers: [OidcConfigService, OidcSecurityService],
  bootstrap: [AppComponent],
})
export class AppModule {
  constructor(private oidcConfigService: OidcConfigService) {
    this.oidcConfigService.withConfig({
      stsServer: 'https://pingfederate.example.com', // PingFederate Authorization Server URL
      redirectUrl: window.location.origin + '/callback', // Your redirect URL
      clientId: 'your-client-id', // Client ID from PingFederate
	  clientSecret: 'your-client-secret', // Client Secret from PingFederate (will be used during the token exchange)
      scope: 'openid profile email', // Scopes you need
      responseType: 'code', // Authorization Code Flow
      postLogoutRedirectUri: window.location.origin, // Where to redirect after logout
      useRefreshToken: false, // Use refresh token
    });
  }
}

stsServer: URL of the PingFederate authorization server.
clientId: Your client ID provided by PingFederate.
clientSecret: The secret associated with the client ID, used during the token exchange.
responseType: Set to code for Authorization Code Flow (without PKCE).
useRefreshToken: Set to false as you've requested to avoid refresh tokens.


Step 2: Add the Authorization and Callback Routes
To handle the redirect from PingFederate after the user has authenticated, you need to create a route that captures the authorization code.

Add the following route to your app-routing.module.ts:

import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AppComponent } from './app.component';

const routes: Routes = [
  { path: 'callback', component: AppComponent }, // Handle callback
  // Add other routes here as needed
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }

The /callback route will handle the redirect from PingFederate after the user has authenticated.

Step 3: Initialize the OIDC Client
In your app.component.ts, inject the OidcSecurityService and call checkAuth() to trigger the authentication flow if the user is not authenticated.

import { Component, OnInit } from '@angular/core';
import { OidcSecurityService } from 'angular-auth-oidc-client';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {

  constructor(private oidcSecurityService: OidcSecurityService) {}

  ngOnInit(): void {
    this.oidcSecurityService.checkAuth().subscribe(({ isAuthenticated }) => {
      if (!isAuthenticated) {
        // If not authenticated, redirect to PingFederate login
        this.oidcSecurityService.authorize();
      }
    });
  }

  login() {
    this.oidcSecurityService.authorize(); // Redirects to PingFederate login
  }

  logout() {
    this.oidcSecurityService.logoff(); // Logs out the user
  }
}

In this code:

checkAuth(): This checks if the user is authenticated.
authorize(): If the user is not authenticated, it will redirect them to PingFederate for authentication.


Step 4: Handle the Callback and Exchange the Authorization Code
When PingFederate redirects the user back to your application after authentication, it will include the authorization code and a state parameter in the URL.

The angular-auth-oidc-client library will automatically handle this callback, extract the authorization code, and exchange it for an access token and ID token. If you want to customize how the callback is handled, you can configure it in the callback route (/callback).

Since the angular-auth-oidc-client library automatically processes the callback, no additional code is necessary in the callback route itself.

However, to make sure that the authorization code is exchanged properly, ensure that you are using the correct clientSecret in the configuration above (as PingFederate will need this during the token exchange process).

Step 5: Protect Routes and Make Authenticated API Calls
After authentication, you can use the access token to make API calls. The library provides a getAccessToken() method to retrieve the access token and add it to your HTTP requests.

Here’s an example of how to make authenticated API calls:

import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Component, OnInit } from '@angular/core';
import { OidcSecurityService } from 'angular-auth-oidc-client';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {

  constructor(
    private http: HttpClient,
    private oidcSecurityService: OidcSecurityService
  ) {}

  ngOnInit(): void {
    this.loadUserProfile();
  }

  loadUserProfile() {
    this.oidcSecurityService.getAccessToken().subscribe((accessToken) => {
      const headers = new HttpHeaders().set('Authorization', `Bearer ${accessToken}`);
      this.http.get('https://api.example.com/user-profile', { headers })
        .subscribe((response) => {
          console.log(response);
        });
    });
  }
}

In this code:

In this code:

getAccessToken(): Retrieves the access token from the angular-auth-oidc-client library.
The Authorization header is set with the token: Bearer ${accessToken}.
An authenticated request is made to https://api.example.com/user-profile.

Step 6: Handle Token Expiry
Since the refresh token functionality is disabled, you will need to handle the case where the access token expires. The library will automatically attempt to re-authenticate the user if the access token is expired, redirecting them back to PingFederate.

If you need to manually check token expiration or initiate re-authentication, you can use the following methods from the OidcSecurityService:

getIsAccessTokenExpired(): Returns true or false to check if the token has expired.
authorize(): If the token has expired, this can be used to trigger re-authentication.


By following these steps, your Angular application will be integrated with PingFederate using the Authorization Code Flow. You will:

Redirect the user to PingFederate for authentication.
Use the client secret to exchange the authorization code for an access token.
Make authenticated API calls by passing the access token in the Authorization header.
This integration is secure and simple, thanks to the angular-auth-oidc-client library, which handles much of the complexity behind OAuth 2.0 and OIDC.














