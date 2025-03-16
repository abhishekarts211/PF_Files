Integration of PingFederate Authentication in React SPA Using PKCE Flow

This documentation outlines the process for integrating PingFederate authentication in a React Single Page Application (SPA) using the PKCE flow. The flow ensures secure authentication and protects against common security risks like CSRF (Cross-Site Request Forgery) attacks.

The process consists of the following steps:

Generate the Code Verifier and Code Challenge (PKCE flow)
Initiate the Authorization Request to PingFederate
Handle the Callback and Exchange Authorization Code for Access Token
Make Authenticated API Calls Using the Access Token
Logout Functionality


Step 1: Install Necessary Libraries
For the authentication process, you will need some libraries to manage the OAuth2 flow. In this case, we will use oidc-client, a popular library that simplifies handling the OAuth2 and OpenID Connect flows.

Install oidc-client
Run the following command to install the oidc-client library:

npm install oidc-client

This library simplifies the OAuth2 flow, including code challenge, authorization code exchange, and token storage.


Step 2: Set Up OAuth2 Configuration
Before you can start implementing the flow, you need to configure the OAuth2 parameters. This includes setting up your PingFederate Authorization Server URL, client ID, and redirect URI.

Create OAuth Configuration File
Create a configuration file src/auth/OAuthConfig.js to define the OAuth2 settings.

import { UserManager } from 'oidc-client';

// Replace with your PingFederate OAuth2 configuration
const config = {
    authority: 'https://your-pingfederate-instance.com',  // Replace with PingFederate Authorization Server URL
    client_id: 'your-client-id',  // Replace with your PingFederate Client ID
    redirect_uri: 'http://localhost:3000/callback',  // Redirect URI registered in PingFederate
    response_type: 'code',  // We are using the Authorization Code flow
    scope: 'openid profile',  // Scopes you need for authentication
    post_logout_redirect_uri: 'http://localhost:3000/',  // URL to redirect after logout
    filterProtocolClaims: true,  // Filters out protocol claims
    loadUserInfo: true  // Optionally, load user info from the OIDC provider
};

export const userManager = new UserManager(config);

authority: The PingFederate OAuth2 authorization endpoint.
client_id: Your client ID registered in PingFederate.
redirect_uri: The URI PingFederate will redirect to after authentication.
scope: Scopes you wish to request for the authentication flow (e.g., openid, profile).

Step 3: Generate the Code Verifier and Code Challenge
In the PKCE (Proof Key for Code Exchange) flow, we generate a code verifier and code challenge to ensure secure communication between the client and the authorization server.

Create Utility for PKCE Generation
Create a file src/auth/PKCEUtils.js to generate the code verifier, code challenge, and state parameter (for CSRF protection).

// Utility to generate a random string of a specified length
function generateRandomString(length) {
    const charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    let result = '';
    for (let i = 0; i < length; i++) {
        result += charset.charAt(Math.floor(Math.random() * charset.length));
    }
    return result;
}

// Utility to create a code verifier
export function createCodeVerifier() {
    return generateRandomString(128);
}

// Utility to create a code challenge from a code verifier
export function createCodeChallenge(codeVerifier) {
    return new Promise((resolve, reject) => {
        const encoder = new TextEncoder();
        const data = encoder.encode(codeVerifier);

        // Create a SHA-256 hash of the code verifier
        window.crypto.subtle.digest('SHA-256', data)
            .then(hash => {
                const base64Url = btoa(String.fromCharCode(...new Uint8Array(hash)))
                    .replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
                resolve(base64Url);
            })
            .catch(reject);
    });
}

// Utility to generate a random state parameter for CSRF protection
export function createState() {
    return generateRandomString(32); // 32 characters is a good length for the state
}


createCodeVerifier() generates a random string to be used as the code verifier.
createCodeChallenge() generates the code challenge by hashing the code verifier using SHA-256.
createState() generates a random state string to protect against CSRF attacks.



Step 4: Initiate the Authorization Request
After generating the code verifier, code challenge, and state parameter, the next step is to redirect the user to the PingFederate authorization page.

Initiate Authorization Request
Create a file src/auth/Authorization.js that will initiate the OAuth2 authorization request:

import { userManager } from './OAuthConfig';
import { createCodeVerifier, createCodeChallenge, createState } from './PKCEUtils';

export async function initiateAuthorization() {
    const codeVerifier = createCodeVerifier();  // Generate code verifier
    const codeChallenge = await createCodeChallenge(codeVerifier);  // Generate code challenge
    const state = createState();  // Generate state parameter to prevent CSRF attacks

    // Store the code verifier and state in sessionStorage
    sessionStorage.setItem('codeVerifier', codeVerifier);
    sessionStorage.setItem('state', state);

    // Build the authorization URL
    const authorizationURL = `${userManager.settings.authority}/as/authorization.oauth2?response_type=code&client_id=${userManager.settings.client_id}&redirect_uri=${userManager.settings.redirect_uri}&scope=${userManager.settings.scope}&code_challenge=${codeChallenge}&code_challenge_method=S256&state=${state}`;

    // Redirect the user to the authorization server
    window.location.href = authorizationURL;
}

What happens here?
We generate the code verifier, code challenge, and state using our utility functions.
We build the authorization URL that the user will be redirected to for authentication.
The state and code verifier are stored in sessionStorage to verify after the callback.


Step 5: Handle the Callback and Exchange Authorization Code for Access Token
Once the user authenticates, PingFederate will redirect the user back to your app with an authorization code and state in the query parameters. We need to handle this in a callback component and exchange the code for an access token.

Handle the Callback
Create a src/auth/Callback.js component to handle the callback and exchange the authorization code:

import React, { useEffect } from 'react';
import { userManager } from './OAuthConfig';
import { exchangeAuthorizationCode } from './Token'; // Token exchange function

const Callback = () => {
    useEffect(() => {
        // Parse the query params from the URL
        const params = new URLSearchParams(window.location.search);
        const authorizationCode = params.get('code');
        const stateFromUrl = params.get('state');
        const stateFromSession = sessionStorage.getItem('state');

        // Check for state mismatch (prevent CSRF attack)
        if (stateFromUrl !== stateFromSession) {
            console.error('State mismatch! Possible CSRF attack detected');
            return;
        }

        if (authorizationCode) {
            // Exchange the authorization code for an access token
            exchangeAuthorizationCode(authorizationCode)
                .then((data) => {
                    console.log('Access Token:', data.access_token);
                    // Store the access token in sessionStorage for later use
                    sessionStorage.setItem('access_token', data.access_token);
                    // Redirect to home page or protected route
                    window.location.href = '/';
                })
                .catch((error) => {
                    console.error('Error exchanging authorization code:', error);
                });
        } else {
            console.error('Authorization code not found');
        }
    }, []);

    return <div>Processing authentication...</div>;
};

export default Callback;


What happens here?
State check: We check if the state parameter returned from PingFederate matches the state stored in sessionStorage.
If valid, we call the exchangeAuthorizationCode function to exchange the code for an access token.



Step 6: Exchange Authorization Code for Access Token
The authorization code returned in the callback needs to be exchanged for an access token.

Exchange the Code for Access Token
Create a file src/auth/Token.js to handle the token exchange:

const tokenEndpoint = 'https://your-pingfederate-instance.com/as/token.oauth2'; // Replace with your token endpoint

export async function exchangeAuthorizationCode(authorizationCode) {
    const codeVerifier = sessionStorage.getItem('codeVerifier'); // Get the stored code verifier

    const body = new URLSearchParams();
    body.append('grant_type', 'authorization_code');
    body.append('code', authorizationCode);
    body.append('redirect_uri', 'http://localhost:3000/callback'); // Redirect URI
    body.append('client_id', 'your-client-id'); // Client ID
    body.append('code_verifier', codeVerifier); // The code verifier to complete PKCE flow

    const response = await fetch(tokenEndpoint, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
    });

    const data = await response.json();
    if (data.access_token) {
        return data;  // Return the access token data
    } else {
        throw new Error('Failed to obtain access token');
    }
}


What happens here?
The authorization code is sent to the token endpoint along with the code verifier to exchange it for an access token.



Step 7: Make Authenticated API Calls Using the Access Token
Now that you have the access token, you can use it to make authenticated API requests.

Make API Requests
Create a file src/api/UserAPI.js to fetch user information using the access token:


export async function getUserInfo() {
    const accessToken = sessionStorage.getItem('access_token');

    if (!accessToken) {
        throw new Error('Access token is missing');
    }

    const response = await fetch('https://your-pingfederate-instance.com/api/userinfo', {
        method: 'GET',
        headers: {
            'Authorization': `Bearer ${accessToken}`,
        },
    });

    const data = await response.json();
    return data;
}

Authorization header: Use the access token to authenticate API requests by adding it to the Authorization header as a Bearer token.


Step 8: Logout
To allow the user to log out, call the signoutRedirect method.

Logout Functionality
Create a file src/auth/Logout.js:

import { userManager } from './OAuthConfig';

export function logout() {
    userManager.signoutRedirect()
        .then(() => {
            console.log('User logged out');
            sessionStorage.removeItem('access_token');  // Clear the access token
            window.location.href = '/';  // Redirect to home page
        })
        .catch((error) => {
            console.error('Error during sign-out', error);
        });
}


signoutRedirect: This method will log the user out and redirect them to the PingFederate logout endpoint.


The userManager is an instance of the UserManager class from the oidc-client library. It is used to handle the entire OpenID Connect (OIDC) flow and OAuth2 authentication in a web application.

The UserManager class provides methods to facilitate the authentication process, manage user sessions, and handle the OAuth2 and OpenID Connect flows.

By following these steps, you've successfully integrated PingFederate authentication in your React SPA using the PKCE flow. Here's a recap of the steps:

Installed the oidc-client library.
Configured OAuth2 settings for PingFederate.
Generated code verifier, code challenge, and state for PKCE.
Initiated the authorization request and redirected the user to PingFederate.
Handled the callback, exchanged the authorization code for an access token, and made authenticated API calls.
Implemented logout functionality.
This method ensures a secure OAuth2 authentication flow with CSRF protection, token management, and user session handling in a modern React application.









