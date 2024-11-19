import logo from './logo.svg';
import './App.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import LoginView from './Pages/Login';
import RegistrationView from './Pages/Register';

function App() {

  return (
    <div className="App">
      <Router>
      <Routes>
        <Route path="/" element={<LoginView/>} />
        <Route path="/register" element={<RegistrationView />} />
      </Routes>
      </Router>
    </div>
  );
}

export default App;
