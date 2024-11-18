import React, { useState, useEffect } from 'react';
import FireAuth from '../Firebase/Auth';
import socket from '../SocketIO/socketio.js'

const LoginView = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState(null);  
  const [user, setUser] = useState(null);

  const auth = new FireAuth();

    useEffect(() => {  
      socket.emit("fromReact", {
        "message": "React connected!"
      })
  },[]);

  const handleLogin = async (e) => {
    e.preventDefault();  
    setError(null); 

    if (!email || !password) {
      setError('Please complete the form.');
    } else {
      const loggedIn = await auth.AuthenticateUser(email, password)

      if (loggedIn.success) {
        setUser(loggedIn.user)
        socket.emit("reactLogin", {
            "message": "React user logged in by Firebase Authentication!", 
            "user": user
            })
      } else {
        setError(loggedIn.error);
      }
    }
  };

  return (
    <div style={{ maxWidth: '400px', margin: 'auto', padding: '20px' }}>
      <h1 style={{ textAlign: 'center', fontStyle: 'italic' }}>Login</h1>

      {error && (
        <div style={{ color: 'red', marginBottom: '16px' }}>
          {error}
        </div>
      )}

      <form onSubmit={handleLogin}>
        {/* Username Field */}
        <div style={{ marginBottom: '16px' }}>
          <label htmlFor="username">Email</label>
          <input
            type="text"
            id="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Enter your email address"
            style={{
              width: '100%',
              padding: '10px',
              border: '1px solid #ccc',
              borderRadius: '4px',
            }}
          />
        </div>

        {/* Password Field */}
        <div style={{ marginBottom: '16px' }}>
          <label htmlFor="password">Password</label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Enter your password"
            style={{
              width: '100%',
              padding: '10px',
              border: '1px solid #ccc',
              borderRadius: '4px',
            }}
          />
        </div>

        <button
          type="submit"
          style={{
            width: '100%',
            padding: '10px',
            backgroundColor: 'white',
            color: 'black',
            border: 'none',
            borderRadius: '4px',
            cursor: 'pointer',
          }}
        >
          Submit
        </button>
      </form>
    </div>
  );
};

export default LoginView;