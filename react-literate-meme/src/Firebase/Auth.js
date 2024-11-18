import firebase from "./Firebase";

class FireAuth {

    CreateUser(email, password) {
        return firebase.auth().createUserWithEmailAndPassword(email, password)
        .then((userCredential) => {
            const user = userCredential.user;
            console.log("User created:", user);
            return { success: true, user }; 
        })
        .catch((error) => {
            console.error("Error code:", error.code);
            console.error("Error message:", error.message);
            return { success: false, error };
        });
    }''

    AuthenticateUser(email, password) {
        return firebase.auth().signInWithEmailAndPassword(email, password)
            .then((userCredential) => {
                var user = userCredential.user;
                console.log("User authenticated:", user);
                return { success: true, user };
            })
            .catch((error) => {
                console.error("Error code:", error.code);
                console.error("Error message:", error.message);
                return { success: false, user: null };
            });
    };

    AuthenticationStateObserver() {
        firebase.auth().onAuthStateChanged((user) => {
            if (user) {
                console.log("User signed in:", user);
                return { success: true, user };
            } else {
                console.log("User signed out.");
                return { success: false, user: null };
            }
          });
    }

    GetCurrentUser() {
        const user = firebase.auth().currentUser;
        if (user) {
            console.log("Current user:", user);
            return { success: true, user };
        } else {
            console.log("No user signed in.");
            return { success: false, user: null };
        }
    };

    UpdateDisplayName(name) {
        const user = firebase.auth().currentUser;

        user.updateProfile({
            displayName: name,
        }).then((user) => {
            return { success: true, user }
        }).catch((error) => {
            console.error("Error code:", error.code);
            console.error("Error message:", error.message);
            return { success: false, user: null };
        }); 
    };

    UpdatePhotoURL(url) {
        const user = firebase.auth().currentUser;

        user.updateProfile({
            photoURL: url
        }).then((user) => {
            return { success: true, user }
        }).catch((error) => {
            console.error("Error code:", error.code);
            console.error("Error message:", error.message);
            return { success: false, user: null };
        }); 
    };

    UpdateEmail(email) {
        const user = firebase.auth().currentUser;

        user.updateEmail(email).then((user) => {
            return { success: true, user }
        }).catch((error) => {
            console.error("Error code:", error.code);
            console.error("Error message:", error.message);
            return { success: false, user: null };
        });
    };

    SendEmailVerification() {
        firebase.auth().currentUser.sendEmailVerification()
            .then(() => {
                return { success: true, message: "Email verification sent." }
            });
    };

    LogoutUser() {
        firebase.auth().signOut().then(() => {
            return { success: true, message: "User signed out." }
        }).catch((error) => {
            console.error("Error code:", error.code);
            console.error("Error message:", error.message);
            return { success: false, message: `${error.code}: ${error.message}` };
          });
    }

    DeleteUser() {
        const user = firebase.auth().currentUser;

        user.delete().then(() => {
            return { success: true, message: "User deletedt." }
        }).catch((error) => {
            console.error("Error code:", error.code);
            console.error("Error message:", error.message);
            return { success: false, message: `${error.code}: ${error.message}` };
        });
    }

};

export default FireAuth;