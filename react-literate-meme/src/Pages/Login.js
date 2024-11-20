import React, { useState, useEffect } from 'react';
import FireAuth from '../Firebase/Auth.js';
import socket from '../SocketIO/socketio.js'
import Container from 'react-bootstrap/Container';
import Form from 'react-bootstrap/Form';
import Button from 'react-bootstrap/Button';
import { Link } from 'react-router-dom';
import Divider from '../Components/Divider.js';

const LoginView = () => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState(null);  
    const [user, setUser] = useState(null);
    const auth = new FireAuth();

    const [viewportSize, setViewportSize] = useState({
        width: window.innerWidth,
        height: window.innerHeight,
      });
    
      useEffect(() => {
        const handleResize = () => {
          setViewportSize({
            width: window.innerWidth,
            height: window.innerHeight,
          });
        };
    
        window.addEventListener('resize', handleResize);
    
        // Clean up the event listener on component unmount
        return () => window.removeEventListener('resize', handleResize);
      }, []);

      const handleLogin = async (e) => {
        e.preventDefault();  
        setError(null); 
    
        if (!email || !password) {
          setError('Please complete the form.');
        } else {
          const loggedIn = await auth.AuthenticateUser(email, password)
    
          if (loggedIn.success) {
            setUser(loggedIn.user)
            socket.emit("FireAuth", {
                "message": "User logged in by Firebase Authentication via React.", 
                "user": loggedIn.user
                })
          } else {
            setError(loggedIn.error);
          }
        }
      };

      const style = {
        MainContainer: {
          height: "100vh", // Ensure the container fills the full height of the viewport
          display: "flex",
          justifyContent: "center", // Center content horizontally
          alignItems: "center", // Center content vertically
        },
        FlexWrapper: {
          display: "flex",
          flexDirection: "column", // Stack items vertically
          justifyContent: "space-between", // Push content to the top and bottom
          height: "100%", // Fill the container height
          width: "100%", // Optional: Match container width
          maxWidth: "400px", // Optional: Limit form width
        },
        LoginForm: {
          marginTop: "auto",
          marginBottom: "auto", // Push form content to the top
        },
        RegisterLink: {
          alignSelf: "center", // Center the link horizontally
          marginTop: "auto", // Push the link to the bottom
          textDecoration: "none", // Optional: Style the link
          color: "black", // Optional: Link color
          padding: 15
        },
        FormLabel: {
          textAlign: "left", // Keep labels aligned left
        },
        ErrorText: {
          color: "red",
          marginTop: "10px",
        },
      };

    return (
    <Container fluid style={style.MainContainer}>
      <div style={style.FlexWrapper}>
        <Form style={style.LoginForm}>
          <h1>Login</h1>
          <Divider/>
          <Form.Group className="mb-3" controlId="formBasicEmail">
            {/* <Form.Label style={style.FormLabel}>Email address</Form.Label> */}
            <Form.Control
              type="email"
              placeholder="Enter email"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
            />
          </Form.Group>

          <Form.Group className="mb-3" controlId="formBasicPassword">
            {/* <Form.Label style={style.FormLabel}>Password</Form.Label> */}
            <Form.Control
              type="password"
              placeholder="Password"
              value={password}
              onChange={(event) => setPassword(event.target.value)}
            />
          </Form.Group>
          <Button variant="light" type="submit" onClick={handleLogin}>
            Submit
          </Button>
          <h3 style={style.ErrorText}>{error}</h3>
        </Form>

        {/* Position the link at the bottom */}
        <Link to="/register" style={style.RegisterLink}>
          Register New Account
        </Link>
      </div>
    </Container>
    );
};

export default LoginView;