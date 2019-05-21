pragma solidity >=0.4.14 <0.6.0;
pragma experimental ABIEncoderV2;
//import './DateTime.sol';
//import './HexUtils.sol';
import './strings.sol';
// import './FogDeviceRegistration.sol';
contract FogBlockchainAuthentication{
            using strings for *;
string public s; 
event Log(string text);
    address      public  owner;
      struct Authentication {
        address requesteddeviceid;
        string deviceinfo;
        string previousblock;
        address accessdeviceid;
        string permissions;
        uint timelease;
    }

    mapping (address => Authentication) fogdeviceauth;
      string ipfsusercollagepicaddress;
      
      struct FogDevice {
      string modelname;
        address deviceid;
        uint32 manufacturerid;
        string locations;
        string usercollagepicaddress;
        string deviceconfiguration;
        int authcoins;
        int registertime;
    }
    // Stored devices 
    mapping (address => FogDevice) fogdevices;

 
    function sendImageHash(string ipfshash) public {
    ipfsusercollagepicaddress = ipfshash;
    }

 function getImageHash() public  returns (string x) {
   return ipfsusercollagepicaddress;
 }

    
    function register(string name,  string deviceconfiguration,uint32 manufacturerid,string locations,string ipfsusercollagepicaddress) 
             public returns (bool res) {
        FogDevice dev = fogdevices[msg.sender];
        if ( dev.deviceid != 0x0) {
            return false;
        }
        dev.modelname = name;
        dev.deviceid = msg.sender;
        dev.registertime = 100000;    
        dev.manufacturerid = manufacturerid;
        dev.deviceconfiguration=deviceconfiguration;
        dev.usercollagepicaddress=getImageHash();
        fogdevices[msg.sender] = dev;
        Log("Registered Successfully");
        return true;
    }

    function unregister() public returns (bool res) {
        FogDevice dev = fogdevices[msg.sender];
        delete dev.modelname;
        dev.deviceid = 0x0;
        dev.registertime = 0;
        dev.deviceconfiguration = "";
        dev.usercollagepicaddress="";
         Log("UnRegistered Successfully");
        return true;
    }

    function getDevInfo(address devid) public returns (string name, address deviceid,  string deviceconfiguration,uint32 manufacturerid,string locations,string ipfsusercollagepicaddress) {
        FogDevice dev = fogdevices[devid];
        name = dev.modelname;
        deviceid = dev.deviceid;
        deviceconfiguration = dev.deviceconfiguration;
        manufacturerid=dev.manufacturerid;
        locations=dev.locations;
        ipfsusercollagepicaddress=dev.usercollagepicaddress;
         Log("Device Registered Successfully");
        return(name,deviceid,deviceconfiguration,manufacturerid,locations,ipfsusercollagepicaddress);
    }

    function getDevLocation(address devid) public returns (string locations) {
        FogDevice dev = fogdevices[devid];
        locations=dev.locations;
        return(string(locations));
    }


    function remove() public returns (bool res) {
        if (msg.sender == owner) {
            suicide(owner);
             Log("Smart contract suicide Successfully");
        }

    }
  
    string public fdlocation;
    
    

    function checkAuthentication(address addr,string name, string deviceconfiguration,uint32 manufacturerid,string locations,string ipfsusercollagepicaddress, uint leasetime) 
    public returns (bool res) {
var(regname,regdeviceid,regdeviceconfiguration,regmanufacturerid,reglocations,regipfsusercollagepicaddress)= getDevInfo(addr);
 if ( keccak256(regname)==keccak256(name) && regmanufacturerid==manufacturerid &&  keccak256(regipfsusercollagepicaddress) == keccak256(ipfsusercollagepicaddress))
{
//     var s = reglocations.toSlice();
    var spliinal=   reglocations.toSlice().find(locations.toSlice());
        
        //bytes memory tempEmptyStringTest = bytes(spliinal.toString()); // Uses memory
if (bytes(spliinal.toString()).length == 0) {
    // emptyStringTest is an empty string
} else {
    
             //bool success= RequestFogdevice(name,locations);
             if(RequestFogdevice(name,locations)==true)
             {
                 giveAccesstoFD(addr,deviceconfiguration,manufacturerid,"Write",locations,leasetime);
              Log("Access granted Successfully");
                 return true;
             }
    // emptyStringTest is not an empty string
}

        
       // var delim = ":".toSlice();
     
        //  if(parts[i].toString()=="locations")
        //  {
        //     bool success= RequestFogdevice(name,locations);
        //     if(success==true)
        //     {
        //         giveAccesstoFD(addr,deviceconfiguration,manufacturerid,"Write",locations);
        //     }
          
        // }
    }
//feed.info.value(10).gas(800)(); 

//string name,  string deviceconfiguration,uint32 manufacturerid,string locations,string ipfsusercollagepicaddress
    Log("Access restricted");
    return false;
    }
    
    function RequestFogdevice(string FD, string location)  public returns (bool res) {
    if( keccak256(getLocation()) == keccak256(location))
    {
         Log("Location FogDevice verified Successfully");
        return true;
    }
    else
      Log("Location FogDevice unverified Successfully");
    return false;
        
    }
    
    
function setLocation(string location, string ipfshash) public returns (bool)
{
     FogDevice dev1 = fogdevices[msg.sender];
         if( keccak256(dev1.usercollagepicaddress) == keccak256(ipfshash)){
          s = dev1.locations.toSlice().concat(location.toSlice());
         dev1.locations=s;
        Log("Location added Successfully to Authorisation list");
         }

}

function getLocation() public returns (string)
{
    return fdlocation;
}


function giveAccesstoFD(address requesteddeviceid,
        string deviceinfo,
        address accessdeviceid,
        string permissions,
        string location, uint leaseTime) expire(msg.sender) public returns (bool)
{
   
     Authentication devauth = fogdeviceauth[msg.sender];
        // Return false if already registered.
      devauth.requesteddeviceid=requesteddeviceid;
        devauth.deviceinfo=deviceinfo;
        devauth.accessdeviceid=accessdeviceid;
        devauth.permissions=permissions;
        fogdeviceauth[msg.sender] = devauth;
        return true;
}


 function getAccessfo(address devid) public returns (address requesteddeviceid,
        string deviceinfo,
        address accessdeviceid,
        string permissions,
        string location, uint leaseTime) {
        Authentication devauth = fogdeviceauth[msg.sender];
        requesteddeviceid= devauth.requesteddeviceid;
        deviceinfo=devauth.deviceinfo;
        accessdeviceid=devauth.accessdeviceid;
        permissions=devauth.permissions;
        leaseTime=devauth.timelease-now;
    }

function autoDisconnect() public returns (bool)
{
    removeAccesstoFD();
}

    modifier expire(address _addr) {
        if (fogdeviceauth[_addr].timelease >= block.timestamp) {
           Authentication devauth = fogdeviceauth[msg.sender];
        // Return false if already registered.
      devauth.requesteddeviceid=0x0;
        devauth.deviceinfo="";
        devauth.previousblock="";
        devauth.accessdeviceid=0x0;
        devauth.permissions="";
        devauth.timelease=0;
        }
        _;
    }

function removeAccesstoFD() public returns (bool)
{
     Authentication devauth = fogdeviceauth[msg.sender];
        // Return false if already registered.
      devauth.requesteddeviceid=0x0;
        devauth.deviceinfo="";
        devauth.previousblock="";
        devauth.accessdeviceid=0x0;
        devauth.permissions="";
        devauth.timelease=0;
        fogdeviceauth[msg.sender] = devauth;
        return true;
}

   

    
}
