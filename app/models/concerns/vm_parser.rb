# This is a class to parse a VM json which comes out of 'gcloud compute instances list -=-foprmat json'
# # This is REALLY complicated and I want to get it right  with a smart mapping
=begin


  {
    "canIpForward": false,
    "confidentialInstanceConfig": {
      "enableConfidentialCompute": false
    },
    "cpuPlatform": "Intel Haswell",
    "creationTimestamp": "2020-12-13T03:07:36.737-08:00",
    "deletionProtection": false,
    "description": "",
    "disks": [
      {
        "autoDelete": true,
        "boot": true,
        "deviceName": "docker-gce-quota-sync-prod",
        "diskSizeGb": "10",
        "guestOsFeatures": [
          {
            "type": "SEV_CAPABLE"
          },
          {
            "type": "VIRTIO_SCSI_MULTIQUEUE"
          },
          {
            "type": "UEFI_COMPATIBLE"
          }
        ],
        "index": 0,
        "interface": "SCSI",
        "kind": "compute#attachedDisk",
        "licenses": [
          "https://www.googleapis.com/compute/v1/projects/cos-cloud-shielded/global/licenses/shielded-cos",
          "https://www.googleapis.com/compute/v1/projects/cos-cloud/global/licenses/cos",
          "https://www.googleapis.com/compute/v1/projects/cos-cloud/global/licenses/cos-pcid"
        ],
        "mode": "READ_WRITE",
        "shieldedInstanceInitialState": {
          "dbs": [
            {
              "content": "MIIEDTCCAvWgAwIBAgIQRtEbux4j2WDjYimBMkIBYjANBgkqhkiG9w0BAQsFADCBizELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDU1vdW50YWluIFZpZXcxFDASBgNVBAoTC0dvb2dsZSBMTEMuMR8wHQYDVQQLExZDb250YWluZXIgT3B0aW1pemVkIE9TMRgwFgYDVQQDEw9VRUZJIERCIEtleSB2MTAwHhcNMjAwODA2MTk0ODU1WhcNMzAwODA0MTk0ODU1WjCBizELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDU1vdW50YWluIFZpZXcxFDASBgNVBAoTC0dvb2dsZSBMTEMuMR8wHQYDVQQLExZDb250YWluZXIgT3B0aW1pemVkIE9TMRgwFgYDVQQDEw9VRUZJIERCIEtleSB2MTAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDQzJHu5A61uBNU6UUUZ5MiXjXwy8Du44BHhisNBpi6cTVHZddJ85iNldE5cPL7hZFJP9n77KyFRCCLxT2CVDNkwMyE2jvJkTz2x2qWvJ-uIuL25Asfgbrv7t1h2Jn790ZLwb9U3qQvqMLvIh_cTtNLat0DaZJsdnJo1MTnFAWrYZZ19KB4j6JJpG_QBnQ-s8XibeSSoa_bMEQTn2OEQFeEcume3CeuZKzXyytMLKkV_z4z-CYddyRwkOFivWUHWq2nVecQQgdyDNWYxGnY4MNsTMYFfv-mhyRzMwhxBFMwMAaEwhTFWsIP6VNwrwIgQaDw3o1fUEuzavTfdNhULaJLAgMBAAGjazBpMA8GA1UdEwEB_wQFMAMBAf8wKQYDVR0OBCIEIEtOsnFY2N1KW7dg9Wd_GEcIwV_a-U2DCn5ZyUsGWickMCsGA1UdIwQkMCKAIEtOsnFY2N1KW7dg9Wd_GEcIwV_a-U2DCn5ZyUsGWickMA0GCSqGSIb3DQEBCwUAA4IBAQCOd9V3WYv589dVov5ZOYo4zSs5PXpts1_8sYvMwvzLBr46LaejfG7KjjIY665Cnik__Zy9N3ZS9-fEeGKrBPE8ClwC06QhLbWDSFIqj2y9qq5FyBW0k1no2UQBnvx4CnLw_BgU3eae0wjv1lpDIbMwxe3E_aucVmzaIX3O83cw2JL9lLm1Psum0L2VHDZSCTP24vzrWoXXo4USHO_tBt_NkYrdkQH5CqGJYtxzKRwHHKEar3vzsiW4DPzlW8kUjRual1eBOKT5YKGbrOA_PJXV9x_7v1f2uAIrqh3HyppDTaGJ7Lux1MDf_hKuwAFI5QJTy9NEojbuUk1tzB4ys_W8",
              "fileType": "X509"
            }
          ],
          "dbxs": [
            {
              "content": "MIIEaDCCA1CgAwIBAgIJAKqfsrCdjyCoMA0GCSqGSIb3DQEBCwUAMH8xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtHb29nbGUgTExDLjEUMBIGA1UECxMLQ2hyb21pdW0gT1MxFzAVBgNVBAMTDlVFRkkgREIgS2V5IHYxMB4XDTE4MTIwODAxMTk0MVoXDTI4MTIwNTAxMTk0MVowfzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDU1vdW50YWluIFZpZXcxFDASBgNVBAoTC0dvb2dsZSBMTEMuMRQwEgYDVQQLEwtDaHJvbWl1bSBPUzEXMBUGA1UEAxMOVUVGSSBEQiBLZXkgdjEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCtZ9U4P5aWlBwiTocmkUjOn2XpvHUlUOnsnhvsm994hAb0MNk2d3fXa8Nz14v9JiBTSf70KU2Zhxb_bSN3KAIv-f7F2AuXte7U9SnzZ02UDmK4TU1bFQW67Y3Gc2hWprCHYEjiRQD4J3WPWhuZnAXqzXQk3uDWVPETi-G9KAM1R-yNxZfoEjfIKhLabDsWqDtnMSovObLoVfwTdnm0WCuYTFtY_CKNxuxeKuzDsC5Su9N3dSFbpGhXJjwUaXPLWY5MFIqIQNBfhmWzDd4PItXaXV3V44IqWTXclE2aSUqkwNrEZ1cRpHG4PYM1aHVmjcO_dWlvthcepTIMIEMAXg2LAgMBAAGjgeYwgeMwHQYDVR0OBBYEFNXbmmdkM0aIsPMyEIv25JRaOPA-MIGzBgNVHSMEgaswgaiAFNXbmmdkM0aIsPMyEIv25JRaOPA-oYGEpIGBMH8xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtHb29nbGUgTExDLjEUMBIGA1UECxMLQ2hyb21pdW0gT1MxFzAVBgNVBAMTDlVFRkkgREIgS2V5IHYxggkAqp-ysJ2PIKgwDAYDVR0TBAUwAwEB_zANBgkqhkiG9w0BAQsFAAOCAQEAJ2vbNymAKTUbRvxnAohHozVUByrKHCq1o8b-bKrgv7Ch0X4itfG8Uwvt0xG7CTpl_Dno92MtpOpFv4ydqox-pP1kTsRcnFNggndXdjpGILIB94KmFiYJvB6RzocJsXsXBa0tULOR24qiB9f93kfITS7Ec60WjFfpgYKEnuEgcV0yBuZzAZbxo1uF4n1hhmVUnKtEI9pX-8geYIIqIYiwwT2jnhFogWw4PeSyg-HMR1CLwwJeH2XDa924LpgHFuR-AbikipAE2vIE0yqJzo0o4tn9-sRuMaQcZ4VQqIzMiniW5H7nGeoQY3ktHX5eq6x-4jFvdLnzzq_D4sS-UWHzOA==",
              "fileType": "X509"
            },
            {
              "content": "MIIEiTCCA3GgAwIBAgIJAOzm3xz71Vu6MA0GCSqGSIb3DQEBCwUAMIGJMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNTW91bnRhaW4gVmlldzEUMBIGA1UEChMLR29vZ2xlIExMQy4xFDASBgNVBAsTC0Nocm9taXVtIE9TMSEwHwYDVQQDExhVRUZJIEtleSBFeGNoYW5nZSBLZXkgdjEwHhcNMTgxMjA4MDExOTQwWhcNMjgxMjA1MDExOTQwWjCBiTELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDU1vdW50YWluIFZpZXcxFDASBgNVBAoTC0dvb2dsZSBMTEMuMRQwEgYDVQQLEwtDaHJvbWl1bSBPUzEhMB8GA1UEAxMYVUVGSSBLZXkgRXhjaGFuZ2UgS2V5IHYxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwg5hvVH6fJSBNji7ynBl1SQzWceL5P3ul6RcB-1s5wXqzXlIHiyRqBdj4hj2pLzpKJGmXWnerIwJOkdsFg7IwZpA4xHE1F-M8XlpuuUn_Xdfccef36ddZEUH6QLwNm96T89F4ujt0omJ-0GV37vBsxEY-hwR3O8XBgyx8TvvYxNnVyTgi19qQdb2ES8-yWJkebdzgugcmNf9K-55fnEiyxWtrvEQb2sowWIS3-b1I_BP85pW2pldh9yQWfb3OY2NJhGSbQSnLi3J0IhRXROEtAXCU4MLTq2cHOpGX0DtJP_g_jD1pnC1O6CCZgVycK4DgZXeDzOG_2Uimhr0y1rcewIDAQABo4HxMIHuMB0GA1UdDgQWBBQEqlpkrYWCzJe69eMUdF1byztBmzCBvgYDVR0jBIG2MIGzgBQEqlpkrYWCzJe69eMUdF1byztBm6GBj6SBjDCBiTELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDU1vdW50YWluIFZpZXcxFDASBgNVBAoTC0dvb2dsZSBMTEMuMRQwEgYDVQQLEwtDaHJvbWl1bSBPUzEhMB8GA1UEAxMYVUVGSSBLZXkgRXhjaGFuZ2UgS2V5IHYxggkA7ObfHPvVW7owDAYDVR0TBAUwAwEB_zANBgkqhkiG9w0BAQsFAAOCAQEAWsd3mq0dADTD7Tx2uYcDeJcJHO0x91hO26p2cqUSox4wPgc4_xk5yiteMgDB5CWLwgcuneDAYYMO1PmktpEvLu9a82gCGxGiww-w78OJTOrs68VM1zB0jqA3X5EyVSwVJqi8idgrnnGsJAcSBosnUI8pNi9SDC3MRPE1q1EUjuDNjsE7t_ItBe-MSMWCH2hpG8unZ7uwWCRfAV3Fkdnq_S5HzDy6-kKyGdj-rprhVeDz2xSyMOlNIJig4uuqU166DTfoQA2TxnMG_TuHt69Z4uZcVwx_HwPs2-vUCCYqZDwuuHKNIEm8kIK8sSPSsp22sC8h-7Klb8wj_d0lzShgkg==",
              "fileType": "X509"
            },
            {
              "content": "MIID0zCCArugAwIBAgIJANuXsNG_1HHxMA0GCSqGSIb3DQEBCwUAMH8xCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMRYwFAYDVQQHDA1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKDAtHb29nbGUgTExDLjEUMBIGA1UECwwLQ2hyb21pdW0gT1MxFzAVBgNVBAMMDlVFRkkgREIgS2V5IHYxMCAXDTE4MDQyNzE1MDYzN1oYDzIyMTgwMzEwMTUwNjM3WjB_MQswCQYDVQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNTW91bnRhaW4gVmlldzEUMBIGA1UECgwLR29vZ2xlIExMQy4xFDASBgNVBAsMC0Nocm9taXVtIE9TMRcwFQYDVQQDDA5VRUZJIERCIEtleSB2MTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALWzFg8obysKXCjnbBTpAM8dMFC2pHX7GpwESNG-FYQI218Y1Ao1p5BttGqPoU5lGNeYUXxgxIqfN18ALHH10gRCRfqbC54faPU1lMr0e0jvi67GgGztyLl4ltAgK7HHTHmtZwghYNS45pKz_LFGm-TlKg-HPZBFT9GtbjRZe5IS2xdKkWM_sPA8qXwzvqmLN3OQckf0KchSUQmB3-wh4vYFV2TEjz10oR0FZO8LFFOOeooukcRDYy219XrdM21APnfszHmfKhzAFddOcYdwKwOL-w9TKVUwCIM70GL_YOtywA17mQkEm0ON79oyQ0daDlZ0ngDxC8xUIASYsRRPOkkCAwEAAaNQME4wHQYDVR0OBBYEFFO6MYgG9CvYp6qAqn_Jm-MANGpvMB8GA1UdIwQYMBaAFFO6MYgG9CvYp6qAqn_Jm-MANGpvMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBAIGyOB_3oFo6f3WoFrdBzimb_weH8hejtCggpcL-8Wdex9VRl5MKi_1GlGbietMDsr1alwdaagam9RafuIQplohTSBnQrU-u-LbtRlCF9C25GDQ70S0QlxAQmt41Sc7kSFTPm6BHauF3b_Raf9AX30MamptoXoAhgMnHAitCn6yCOsRJ_d1t04lqsiqefhf26xItvRnkuxG7-IQnbyGFCGPcjFNAE1thLpL_6y_dprVwTLsvZnsWYj-1Gg1yUkOnCN8Kl3Q3RDVqo98mORUc0bKB-B8_FQsbtmzbb-29nXQJW1FJx0ejqJyDGGBPHAGpwEJTVB3mwWXzBU6Ny7T3dlk=",
              "fileType": "X509"
            },
            {
              "content": "MIID6TCCAtGgAwIBAgIJAKgdcZ45rGMDMA0GCSqGSIb3DQEBCwUAMIGJMQswCQYDVQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNTW91bnRhaW4gVmlldzEUMBIGA1UECgwLR29vZ2xlIExMQy4xFDASBgNVBAsMC0Nocm9taXVtIE9TMSEwHwYDVQQDDBhVRUZJIEtleSBFeGNoYW5nZSBLZXkgdjEwIBcNMTgwNDI3MTUwNjM3WhgPMjIxODAzMTAxNTA2MzdaMIGJMQswCQYDVQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNTW91bnRhaW4gVmlldzEUMBIGA1UECgwLR29vZ2xlIExMQy4xFDASBgNVBAsMC0Nocm9taXVtIE9TMSEwHwYDVQQDDBhVRUZJIEtleSBFeGNoYW5nZSBLZXkgdjEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCbIdHPMQZZU68jI5kz5rmwvo-DQZZJ5amRnAUnBpNllhNQB6TaLUS_D9TIo_0X1e8T21Xk4Pf3D5ckbuQxsJzQ5OVEOb59sJ9AhjVUoxQxuVW-iBzD0mWbxKf2cASy2YRIEcaAAI5QT2SwO8gZy_G8LwAk-vO0vIbynN0WuFLl1Dp2cMQ3CxLSPH-QPSZyGd6o6ewUU9JzboppujXpk43EQH5ZJE_wJb_ujUFWcFzKHb_EkV1hI1TmBJ1-vR2kao4_1hQO6k1zLUR-MyBHY0SRU2OQxBpSez-qt7oItMBc1EanXvq9tqx0ndCTmXQYQplT5wtkPbE9sd5zwbDt8btHAgMBAAGjUDBOMB0GA1UdDgQWBBS5Tmmv3JM8w1mfP9V5xAIdjBhb7TAfBgNVHSMEGDAWgBS5Tmmv3JM8w1mfP9V5xAIdjBhb7TAMBgNVHRMEBTADAQH_MA0GCSqGSIb3DQEBCwUAA4IBAQB9BRTP37ik4jF2BmJJspMA6NHS7mxIckFCYKl-TO8zGFd3mlA6dnEw5WY-tUcBNJpAaHNJV_rzagGPpWMIoy-nAaLSSpnyhEXYTnQvzejYRijN3N0V9tmM0qgViHNBqTxdfcwlst5OUesGHPqgBOt5RRu5OGJ0rkuymWwxHOKIw43hz5FW7vhumbtJ3iy8HSFQIjSYMkr0sOzJhmvnHlpZ4pOoPNyNA9DM6smriH-2-MnJFM9w8bg6zsV5X-6KL464_FuXL_X_IWmAsAbi8Ge8ZMJjEaDrF1qkD4aLvu0MshzEdvrvQO-3Gn3Lmi_RYKR0HKZp7jXTySj76sxt9QK4",
              "fileType": "X509"
            }
          ],
          "keks": [
            {
              "content": "MIIEIjCCAwqgAwIBAgIRAKxVeWkn5a0pF1C0o_HUM6owDQYJKoZIhvcNAQELBQAwgZUxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1Nb3VudGFpbiBWaWV3MRQwEgYDVQQKEwtHb29nbGUgTExDLjEfMB0GA1UECxMWQ29udGFpbmVyIE9wdGltaXplZCBPUzEiMCAGA1UEAxMZVUVGSSBLZXkgRXhjaGFuZ2UgS2V5IHYxMDAeFw0yMDA4MDYxOTQ4NTBaFw0zMDA4MDQxOTQ4NTBaMIGVMQswCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNTW91bnRhaW4gVmlldzEUMBIGA1UEChMLR29vZ2xlIExMQy4xHzAdBgNVBAsTFkNvbnRhaW5lciBPcHRpbWl6ZWQgT1MxIjAgBgNVBAMTGVVFRkkgS2V5IEV4Y2hhbmdlIEtleSB2MTAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC6ZCJ4Oldm1z3gwwAjWqiHRMFrXPwq0XmVmLWoaGUBzeL41VwHK76iQTxl11HYhqaAr_0nmVQAM3M6so6cmydd7l1RPYJpZ3Shy3qO4xxgy30kp4zW00m9EVEdkmh9-9zi_G89uutz7wOb34M2Wrybwa7D5U102DmSoJAoq5z2YrvpjZoGLRGqBBP6A1l-_gRGMAgUMqKbhD1HF1VKXZnIGq9UJcpHhRvQxOG3nlVWk6z8dH-Rnp_9YfEPRORAUF5PUnUL5-I3wr5derIIoeYxc7G2ZuTyRWsF9WVyZ7OquYwxAY4l4xkDJpAvSomHkbfNgtCZyTm2pMIkRou0up5lAgMBAAGjazBpMA8GA1UdEwEB_wQFMAMBAf8wKQYDVR0OBCIEINDkWV5HwgIi6aogGQUbZwWC5Es_Vx9SX5kG8i1xiXxKMCsGA1UdIwQkMCKAINDkWV5HwgIi6aogGQUbZwWC5Es_Vx9SX5kG8i1xiXxKMA0GCSqGSIb3DQEBCwUAA4IBAQCOTmuK7QQ4sP_8qYI2-bkvbQg1Vpq0W_aWtm0AQDw2iEVgfIq8JxNHu61ZhkmBiEhsdaaj7bYt_8owpvxfRnmzMPhQ6iB51vkExjWipD9spgSb8tfp0te6MqTT3omyYI9x4L13wn9ufZtlhZXlVgbjUN1QyevHwNt7Kms8Nd9Jbk9JCV9JoOIjkBpUjpCWCDfdGDD-iGIPzGdS-KjrNiA4udnzkdkO83dFMMvu69a1snCRUshNvHBNPbPRwbRYV9lS_QTwfft7EgbNF0455gblZbejvGJgR1Vhyen0jIPouVWxXe0X7AnGK8Mc3DUQBPVGT4ZR0WChbcwiOavh2t2X",
              "fileType": "X509"
            }
          ],
          "pk": {
            "content": "MIIEGTCCAwGgAwIBAgIQYB8C9RH--O1hXkpp2FVSXjANBgkqhkiG9w0BAQsFADCBkTELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDU1vdW50YWluIFZpZXcxFDASBgNVBAoTC0dvb2dsZSBMTEMuMR8wHQYDVQQLExZDb250YWluZXIgT3B0aW1pemVkIE9TMR4wHAYDVQQDExVVRUZJIFBsYXRmb3JtIEtleSB2MTAwHhcNMjAwODA2MTk0ODQ0WhcNMzAwODA0MTk0ODQ0WjCBkTELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDU1vdW50YWluIFZpZXcxFDASBgNVBAoTC0dvb2dsZSBMTEMuMR8wHQYDVQQLExZDb250YWluZXIgT3B0aW1pemVkIE9TMR4wHAYDVQQDExVVRUZJIFBsYXRmb3JtIEtleSB2MTAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQClSQ15LUf193eJfM6b5etGgz8auvdI72Cclo3fHvwXBzsm5T1QamwYAqrCTcS7MxauCTkmkXTS9ejM4NNpQWF6KG82nR88vRyKO_MnSNL8ZP-rtRu0p1X_mUYXwi0_nPkyPKLR2QJ9H2EOrw_RChWvwnu281WtfUPCYs2t2SjBCF_mgzZI8o3s8wOtL8y-Dmi9T0bGO1wYX2okz51PKbhgVGQA7KJRmeekIxEkiN7GOb_2VQqcdM9c846OlC-8abwgDvrL3YqKqhw8DnSM2AbNpZIgUTd1Ut3X-PWXVKBj3qdxjAyRez8dPWymXDji-CBoBzLsWEkUW87S1coggOABAgMBAAGjazBpMA8GA1UdEwEB_wQFMAMBAf8wKQYDVR0OBCIEIMk0-K2sxOjtSpl-2pXmBWwwvSMGEIThmdDsSxQk2XZQMCsGA1UdIwQkMCKAIMk0-K2sxOjtSpl-2pXmBWwwvSMGEIThmdDsSxQk2XZQMA0GCSqGSIb3DQEBCwUAA4IBAQA7Pmaixb0FuDtpesNGvaBkTGWWMO7bDtx4rQom7zprEnliFJZung08FS3r73ob1urH0lzZm9022nRp8xqcSGk3wDkE9xQppWhvjhf6SOHdwM9_OxVq6no_BPz1PkRYsg4V07cgYPCtp7Ck7ZBI7m3MbLUyg8EG14_tvjKX9Xh2h0FSGuGg8_jjGYCGDtaSPkXBpAWurZ5mC2o9CzGaBJR4f_51I5C2AfHMG0H5T0Kehuyb_IzX9mAwArGmt62e4T9SxdP7LZUNPMEzOrhW1RzXvsD6Vod4uA9h2n_lbZHiBBExM2PMwuoobb-io-W0ARL4OCN5jah0a7q1ax6UYJK-",
            "fileType": "X509"
          }
        },
        "source": "https://www.googleapis.com/compute/v1/projects/foobarbaz/zones/us-central1-a/disks/docker-gce-quota-sync-prod",
        "type": "PERSISTENT"
      }
    ],
    "displayDevice": {
      "enableDisplay": false
    },
    "fingerprint": "MhZBzepSMeM=",
    "id": "6675884776646789911",
    "kind": "compute#instance",
    "labelFingerprint": "hV_ru_adlOc=",
    "labels": {
      "container-vm": "cos-stable-85-13310-1041-38",
      "env": "prod",
      "purpose": "run-gce-quota-sync-py"
    },
    "lastStartTimestamp": "2020-12-13T03:21:52.660-08:00",
    "lastStopTimestamp": "2020-12-13T03:21:40.432-08:00",
    "machineType": "https://www.googleapis.com/compute/v1/projects/foobarbaz/zones/us-central1-a/machineTypes/e2-small",
    "metadata": {
      "fingerprint": "T-bhYChdvBg=",
      "items": [
        {
          "key": "google-logging-enabled",
          "value": "true"
        },
        {
          "key": "gce-container-declaration",
          "value": "spec:\n  containers:\n    - name: docker-gce-quota-sync-prod\n      image: gcr.io/foobarbaz/ricc-gce-quota-sync\n      env:\n        - name: OPT_PROJECT\n          value: foobarbaz\n        - name: OPT_STACKDRIVER_LOGGING\n          value: 'true'\n        - name: OPT_VERBOSE\n          value: 'true'\n      stdin: false\n      tty: false\n  restartPolicy: Always\n\n# This container declaration format is not public API and may change without notice. Please\n# use gcloud command-line tool or Google Cloud Console to run Containers on Google Compute Engine."
        }
      ],
      "kind": "compute#metadata"
    },
    "name": "docker-gce-quota-sync-prod",
    "networkInterfaces": [
      {
        "accessConfigs": [
          {
            "kind": "compute#accessConfig",
            "name": "External NAT",
            "natIP": "42.42.43.43",
            "networkTier": "PREMIUM",
            "type": "ONE_TO_ONE_NAT"
          }
        ],
        "fingerprint": "b2ZAToXr3Cc=",
        "kind": "compute#networkInterface",
        "name": "nic0",
        "network": "https://www.googleapis.com/compute/v1/projects/foobarbaz/global/networks/default",
        "networkIP": "10.240.0.90"
      }
    ],
    "reservationAffinity": {
      "consumeReservationType": "ANY_RESERVATION"
    },
    "scheduling": {
      "automaticRestart": true,
      "onHostMaintenance": "MIGRATE",
      "preemptible": false,
      "provisioningModel": "STANDARD"
    },
    "selfLink": "https://www.googleapis.com/compute/v1/projects/foobarbaz/zones/us-central1-a/instances/docker-gce-quota-sync-prod",
    "serviceAccounts": [
      {
        "email": "134140879415@project.gserviceaccount.com",
        "scopes": [
          "https://www.googleapis.com/auth/cloud-platform"
        ]
      }
    ],
    "shieldedInstanceConfig": {
      "enableIntegrityMonitoring": true,
      "enableSecureBoot": false,
      "enableVtpm": true
    },
    "shieldedInstanceIntegrityPolicy": {
      "updateAutoLearnPolicy": true
    },
    "startRestricted": false,
    "status": "RUNNING",
    "tags": {
      "fingerprint": "42WmSpB8rSM="
    },
    "zone": "https://www.googleapis.com/compute/v1/projects/foobarbaz/zones/us-central1-a"
  }

=end
module VmParser
  extend ActiveSupport::Concern

  @@vm_smart_mapping = [
    name: "name",
    zone: "zone",
    status: "status",
    # TODO https://github.com/winebarrel/ruby-jq to get it this way
    ip: "networkInterfaces[0].accessConfigs[0].natIP" # ["networkInterfaces"][0]["accessConfigs"][0]["natIP"]
  ]

  def self.autoparse()
    Dir.glob("db/fixtures/gce_vms/*.json").each { |file| parseJsonFile(file) }
  end

  # Generate all files based on gcloud and these projects: INTERESTING_PROJECT_IDS
  def self.autogenerate(interesting_projects = nil)
    interesting_projects ||= ENV.fetch("INTERESTING_PROJECT_IDS").split(",")
    puts "AutoGenerate() interesting_projects: #{interesting_projects}"
    unless interesting_projects.is_a?(Array)
      raise "interesting_projects is not an array!"
    end
    interesting_projects.each do |project_id|
      filename =
        "db/fixtures/gce_vms/gcloud_instances_list.project_id=#{project_id}.json"
      ret =
        `gcloud --project #{project_id} compute instances list --format json | tee '#{filename}'`
      puts "Correctly(?) created #{filename}..."
    end
  end

  # should parse a list of
  def self.parseJsonFile(json_file)
    n_parsed = 0
    JSON
      .parse(File.read(json_file))
      .each do |f|
        parse_single_vm_into_model(f)
        n_parsed += 1
      end
    puts "parseJsonFile('#{json_file}'): parsed #{n_parsed} entities."
  end

  def self.parse_single_vm_into_model(hash, opts = {})
    func_version = "0.1"
    opts_debug = opts.fetch :debug, true

    # Extracting project id and number, needed for project search vs creation
    project_id = hash["machineType"].split("/")[6]
    # "email": "134140879415@project.gserviceaccount.com",
    # if hash["serviceAccounts"].nil?
    #   #puts hash
    #   puts hash["serviceAccounts"]
    #   #puts hash["serviceAccounts"][0]
    #   #puts hash["serviceAccounts"][0]["email"]
    #   raise "project_number not found, look better: #{hash["serviceAccounts"]}"
    # end
    project_number =
      begin
        hash["serviceAccounts"][0]["email"].split("@")[0].to_i
      rescue StandardError
        42
      end

    # Additional 'useless' things to ease redability and add to debug puts :)
    name = hash["name"]
    pub_ip =
      begin
        hash["networkInterfaces"][0]["accessConfigs"][0]["natIP"]
      rescue StandardError
        nil
      end
    # "machineType": "https://www.googleapis.com/compute/v1/projects/foobarbaz/zones/us-central1-a/machineTypes/e2-small",
    project =
      Project.find_or_create_by(
        project_id: project_id,
        project_number: project_number
      )
    raise "Not a project!" unless project.is_a?(Project)
    #puts hash["disks"][0]["deviceName"]
    disk1_size_gb = hash["disks"][0]["diskSizeGb"].to_i
    disk1_name = hash["disks"][0]["deviceName"]

    # Zone: https://www.googleapis.com/compute/v1/projects/foo-bar-baz-sample/zones/us-central1-a
    zone = hash["zone"] # .split("/").last
    if opts_debug
      puts "DEB Parsing machine: #{pub_ip}\t#{project_id}::#{name} PROJECT=#{project.id}"
    end

    Vm.create(
      name: hash["name"],
      description: hash["description"],
      internal_notes: "Created via parse_single_vm_into_model v#{func_version}",
      machine_type: hash["machineType"],
      internal_ip: hash["networkInterfaces"][0]["networkIP"],
      external_ip: pub_ip,
      self_link: hash["selfLink"],
      zone: zone,
      disk1_size_gb: disk1_size_gb,
      disk1_name: disk1_name,
      status: hash["status"],
      is_preemptible: hash["scheduling"]["preemtpible"],
      project_id: project.id
    )
  end
end
