# Authentication example in Servent using JWT

### What do you mean by authentication and authorization?
Authentication is the process of verifying the identity of a user. Authorization is the process of verifying that the user has the necessary permissions to access the requested resource.

### What is JWT?
JWT stands for JSON Web Token. It is an open standard that defines a compact and self-contained way for securely transmitting information between parties as a JSON object. This information can be verified and trusted because it is digitally signed.
Basically, JWT is a token that is used to authenticate and authorize users. It is an
encrypted json body that contains user information and a signature that is used to verify the authenticity of the token. Usually, once the user is logged in successfully, the server sends a JWT token to the client and client stores the token (in cookies) . The client then sends this token in the header of every request to the server. The server then verifies the token and allows the user to access the requested resource.

### Flow for authentication using JWT

1. Will create an api for login, which will take email and password as input and return a JWT token.
2. Inside this login api, once we receive email and password, we will check if the user exists in the database and if the password is correct. If yes, we will create a JWT token and return it.
3. Next time, user will send this token in the header of every request to the server.
4. In our auth protected apis, we will check if the token is valid or not. If valid, we will allow the user to access the resource.

That's it. This is how JWT works!