pragma solidity >=0.4.14 <0.6.0;
pragma experimental ABIEncoderV2;
//import './DateTime.sol';
//import './HexUtils.sol';
import './strings.sol';
// import './FogDeviceRegistration.sol';
contract FogBlockchainAuthentication{
            using strings for *;
string public s; 
    address      public  owner;
      struct Authentication {
        address requesteddeviceid;
        string deviceinfo;
        string previousblock;
        address accessdeviceid;
        string permissions;
       // string location;
        uint timelease;
    }

    mapping (address => Authentication) fogdeviceauth;
    //     string regname;
    // address regdeviceid;  string regdeviceconfiguration;
    // uint32 regmanufacturerid;string reglocations;
    // string regipfsusercollagepicaddress;
      string ipfsusercollagepicaddress;
      
      struct FogDevice {
      string modelname;
        address deviceid;
        uint32 manufacturerid;
       // string locations;
        string usercollagepicaddress;
        string deviceconfiguration;
        int authcoins;
        int registertime;
    }
    // Stored devices 
    mapping (address => FogDevice) fogdevices;
  //  byte32 s4;
 event Log(string text1,string text);
 event Logs(string text1,uint32 text);
 event Logint(string text1,int text);

 event Log(string text);
 event Logs(uint32 text);
 event Logint(int text);
    function sendImageHash(string ipfshash) public {
    ipfsusercollagepicaddress = ipfshash;
    }

 function getImageHash() public  returns (string x) {
   return ipfsusercollagepicaddress;
 }

    
    function register(string name,  string deviceconfiguration,uint32 manufacturerid,string ipfsusercollagepicaddress) 
             public returns (bool res) {
        FogDevice dev = fogdevices[msg.sender];
        // Return false if already registered.
        if ( dev.deviceid != 0x0) {
            return false;
        }
        dev.modelname = name;
        dev.deviceid = msg.sender;
        dev.registertime = 100000;    
        dev.manufacturerid = manufacturerid;
        dev.deviceconfiguration=deviceconfiguration;
        dev.usercollagepicaddress=ipfsusercollagepicaddress;
        //dev.locations=locations;
        dev.authcoins=100;
        fogdevices[msg.sender] = dev;
//        s4=sha3(dev.modelname, dev.deviceid,dev.manufacturerid,dev.deviceconfiguration,dev.usercollagepicaddress);
        Log(name,"Registered Successfully");
        return true;
    }

    function unregister() public returns (bool res) {
        FogDevice dev = fogdevices[msg.sender];
        delete dev.modelname;
        dev.deviceid = 0x0;
        dev.registertime = 0;
        dev.deviceconfiguration = "";
        dev.usercollagepicaddress="";
        dev.authcoins=0;
         Log(dev.modelname,"UnRegistered Successfully");
        return true;
    }

    function getDevInfo(address devid) public returns (string name, address deviceid,  string deviceconfiguration,uint32 manufacturerid,string ipfsusercollagepicaddress,int authcoins) {
        FogDevice dev = fogdevices[devid];
        name = dev.modelname;
        deviceid = dev.deviceid;
        deviceconfiguration = dev.deviceconfiguration;
        manufacturerid=dev.manufacturerid;
        //locations=dev.locations;
        ipfsusercollagepicaddress=dev.usercollagepicaddress;
        authcoins=dev.authcoins;
         Log(name,"Device Registered Successfully");
        return(name,deviceid,deviceconfiguration,manufacturerid,ipfsusercollagepicaddress,authcoins);
    }

    


    function remove() public returns (bool res) {
        if (msg.sender == owner) {
            suicide(owner);
             Log("Contract","Smart contract suicide Successfully");
        }

    }
  
    //string public fdlocation;
    
    

    function checkAuthentication(address addr,string name, string deviceconfiguration,uint32 manufacturerid,string ipfsusercollagepicaddress, uint leasetime) 
    public returns (bool res) {
var(regname,regdeviceid,regdeviceconfiguration,regmanufacturerid,regipfsusercollagepicaddress,regauthcoins)= getDevInfo(addr);
 Log("regname ",regname);
 Log("name",name);
 Logs("regmanufacturerid",regmanufacturerid);
 Logs("manufacturerid",manufacturerid);
 Log("regipfsusercollagepicaddress",regipfsusercollagepicaddress);
 Log("ipfsusercollagepicaddress",ipfsusercollagepicaddress);
 Logint("regauthcoins",regauthcoins);
 if ( keccak256(regname)==keccak256(name) && regmanufacturerid==manufacturerid &&  keccak256(regipfsusercollagepicaddress) == keccak256(ipfsusercollagepicaddress) && regauthcoins>1)
{
//     var s = reglocations.toSlice();
   // var spliinal=   //reglocations.toSlice().find(locations.toSlice());
        
        //bytes memory tempEmptyStringTest = //bytes(spliinal.toString()); // Uses memory
regauthcoins=regauthcoins-1;                 giveAccesstoFD(addr,deviceconfiguration,manufacturerid,"Write",leasetime);
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
        //         giveAccesstoFD(addr,deviceconfiguration,manufacturerid,"Write");
        //     }
          
        // }
    }
//feed.info.value(10).gas(800)(); 

//string name,  string deviceconfiguration,uint32 manufacturerid,string locations,string ipfsusercollagepicaddress
    
    Log("Access restricted");
       regauthcoins=regauthcoins-50;
    return false;
    }
    
    
    
    

function giveAccesstoFD(address requesteddeviceid,
        string deviceinfo,
        address accessdeviceid,
        string permissions, uint leaseTime) expire(msg.sender) public returns (bool)
{
   
     Authentication devauth = fogdeviceauth[msg.sender];
        // Return false if already registered.
      devauth.requesteddeviceid=requesteddeviceid;
        devauth.deviceinfo=deviceinfo;
        devauth.accessdeviceid=accessdeviceid;
        devauth.permissions=permissions;
        devauth.timelease=block.timestamp + leaseTime;
        fogdeviceauth[msg.sender] = devauth;
        return true;
}


 function getAccessfo(address devid) public returns (address requesteddeviceid,
        string deviceinfo,
        address accessdeviceid,
        string permissions,
         uint leaseTime) {
        Authentication devauth = fogdeviceauth[msg.sender];
        requesteddeviceid= devauth.requesteddeviceid;
        deviceinfo=devauth.deviceinfo;
        accessdeviceid=devauth.accessdeviceid;
        permissions=devauth.permissions;
        //location=devauth.location;
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
       // devauth.location="";
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
       // devauth.location="";
        devauth.timelease=0;
        fogdeviceauth[msg.sender] = devauth;
        return true;
}

   
    
}

