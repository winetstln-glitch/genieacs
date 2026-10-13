// ZTE Provisioning Script
const now = Date.now();
const cacheTime = now - 300000; // 5 mins

// ZTE PON Optical Power & Mode
declare("InternetGatewayDevice.WANDevice.*.X_ZTE-COM_WANPONInterfaceConfig.RXPower", {value: cacheTime});
declare("InternetGatewayDevice.WANDevice.*.X_ZTE-COM_WANPONInterfaceConfig.TXPower", {value: cacheTime});
declare("InternetGatewayDevice.WANDevice.*.X_ZTE-COM_WANPONInterfaceConfig.PonMode", {value: cacheTime});

// ZTE PPPoE Credentials
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANPPPConnection.*.Username", {value: cacheTime});
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANPPPConnection.*.Password", {value: cacheTime});

// ZTE Web Account SuperPassword
declare("InternetGatewayDevice.X_CU_Function.Web.AdminPassword", {value: cacheTime});
declare("InternetGatewayDevice.X_Authentication.WebAccount.Password", {value: cacheTime});
