import React from "react";

const Divider = ({ color = "#ccc", thickness = "1px", margin = "16px 0" }) => {
    return (
      <div
        style={{
          height: thickness,
          backgroundColor: color,
          margin: margin,
          width: "100%",
        }}
      />
    );
  };
  
  export default Divider;