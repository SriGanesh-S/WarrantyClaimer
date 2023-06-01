

function user_type() {
    const role = document.getElementById('role');
    console.log("role" + role);
    
    
      if (role.value === 'Customer') {
        document.getElementById("customer_details").style.display = "block"; 
        document.getElementById("additional_details").style.display = "block";
        document.getElementById("address").style.display = "block"; 
        document.getElementById("seller_details").style.display = "none"; 

      } else if (role.value == "Seller") {
        document.getElementById("seller_details").style.display = "block";
        document.getElementById("additional_details").style.display = "block";
        document.getElementById("address").style.display = "block"; 
        document.getElementById("customer_details").style.display = "none"; 
       
      }else{
        document.getElementById("customer_details").style.display = "none"; 
        document.getElementById("seller_details").style.display = "none"; 
        document.getElementById("additional_details").style.display = "none"; 
        document.getElementById("address").style.display = "none"; 
      } 
    
  }
