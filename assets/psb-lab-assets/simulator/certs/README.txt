PSB lab device certificates
===========================
Extract the IoT Core "Connect one device" kit (connect_device_package.zip) into this folder.
The simulator expects these files here:

  psb-lab-sensor-01.cert.pem      device certificate
  psb-lab-sensor-01.private.key   device private key (keep it secret)
  psb-lab-sensor-01.public.key    public key (not used by the simulator)
  root-CA.crt                     Amazon Root CA 1

If root-CA.crt is missing, download https://www.amazontrust.com/repository/AmazonRootCA1.pem
and save it in this folder as root-CA.crt.

Then run from C:\psb-lab-assets\simulator:
  python simulate_pi.py --endpoint <IOT-ENDPOINT> --certs-dir certs --interval 10
