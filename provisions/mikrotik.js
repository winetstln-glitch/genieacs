// MikroTik TR-069 Provisioning Script
const now = Date.now();
const daily = now - 86400000;

// Device Information
declare("DeviceID.SerialNumber", {value: daily});
declare("DeviceID.ProductClass", {value: daily});
declare("InternetGatewayDevice.DeviceInfo.HardwareVersion", {value: daily});
declare("InternetGatewayDevice.DeviceInfo.SoftwareVersion", {value: daily});

// IP and WAN info
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANIPConnection.*.ExternalIPAddress", {value: daily});
