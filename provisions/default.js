// Default Provisioning Script for GenieACS
const now = Date.now();
const daily = now - 86400000;
const hourly = now - 3600000;

// Device Information
declare("DeviceID.SerialNumber", {value: daily});
declare("DeviceID.Manufacturer", {value: daily});
declare("DeviceID.ProductClass", {value: daily});
declare("InternetGatewayDevice.DeviceInfo.HardwareVersion", {value: daily});
declare("InternetGatewayDevice.DeviceInfo.SoftwareVersion", {value: daily});

// Periodic Inform interval (default 300s = 5m)
declare("InternetGatewayDevice.ManagementServer.PeriodicInformInterval", null, {value: 300});
declare("InternetGatewayDevice.ManagementServer.PeriodicInformEnable", null, {value: true});

// WAN & PPPoE status check
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANPPPConnection.*.ExternalIPAddress", {value: hourly});
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANPPPConnection.*.ConnectionStatus", {value: hourly});
declare("InternetGatewayDevice.WANDevice.*.WANConnectionDevice.*.WANIPConnection.*.ExternalIPAddress", {value: hourly});
