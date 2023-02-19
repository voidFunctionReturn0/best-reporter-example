import 'package:gsheets/gsheets.dart';

class GSheetsAPIConfig {
  static final String spreadsheetId = '1Ktsjmv-uiZ-g5y-hbMed3Vr3VLsX75beC4tDcA3mvZw';

  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "best-reporter-test",
  "private_key_id": "b0b62c4c80fb1dbcd375edd2747eb63388e41c9f",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCtWzpn2pQYfXrl\n367dkhuqobeYraxsnCeOMvWBAzXyZqCwUdvWVfdRyBi7V0rPduicgLFkf5wlJ2nB\n7sQH/o7TjJXmtDHCLE8oPEojNqkaImfUWSfMoNj0C9tPNixqWwxlnriGS6lhwUhM\n+K1FBsjkGqIJ5SaMTpJPdegFaZ/mxPxU44WXoRWlML/7a7qIrk1oVIU1uqttcqOX\nVxoPuKK6d6qzi0h61XEszGjxlHAI1ksSdCupJQUahwm3mElRDTxiL6iM5HpBTW1H\n6BiKOIhabtBPKq3IgbcoPSoUVrT/y6sEF8bcOHKuNQzU8P/9xJAZIIVDqaDbWGj+\n7Wtbuz6JAgMBAAECggEAHQHwLLsaP1vV0fvDKK+/Yea0ED/1Y2ogw05bHsahAwnx\ntvdHnB6f5wcevlBdxAffZfqx1EF3KQ9mhq0zj6vkjdkPJz69OcLMzwyBklFd6/HY\nYmO1wWujyfhm7uL/fR91nFZ6BXzJH8KmHL0azztSp7qeJR47PEyUdmfiFm/Fcil7\nE+rlwC+o7eJ0OBr037zoVVZBXY//A9OLPCl/xb31HtpOzmbiD0fVnZbHChWvF8kY\nYQNusefNgpCF0MsJUFakinALFfCEALKcNgtNAV/5CxNj0XIb45FhLzR2BGfF+S9g\nd0WvTwDFwRqPXAe1rNBCCYV80gTetb4G4tb0K+f6FQKBgQDXVR1zON0HQdL1YWx0\nL4pHjzrJVTcEMD3vfcWgB8bF789qwxU/muXgetLRs6mOdgJX/yVTPXlbf3yl2n0T\nXBA/C8V/dOti1FNSvHpyW6s4ctDhyiX8uLC9JuRxoxLu/6WNYe5zHnHy4c3CMAy6\n0PnPnAQj2asaljcw2NF3zAnLpQKBgQDOGKdOSY9BIcQAkoLeDYKW0otmDkW+BAFH\nwoACw9OQkKjsTCQ/pgDgokdEIKTxcsuKrUwt5NVo99zgktJ6nByJVmylahWbpKOR\nfIFSSjE1elH6PgekigwCMPoxqrzSlAzvcvGnn/Z3Qd7qK+VzPRl+8uHuEcb+noV8\ndSIwnylCFQKBgQCqYZ673PKHG35gyoWWKUew95P8WoD9v25CYbJNvdl6JRZp05Ks\nkVPzGzxU0WQIZTfViP1vr+SmkWl/kjIFb4MrX5UWFN1rhbWocZoxgncoYzEEd383\nSKwP/wYjJHWGxqGoDSUv0Zc4J5M3Y+2upEwGCdz8wO6ySsnAzM5xi/D0QQKBgFai\nXGn3WAW8COVosSRgr31xAfIjm8OVcWhV5XPEF8IUXT3/f9lVkdbbwHNt+YgZhmBE\nGtrL773RO4MXlOy/hOtibgdWwcCMg8mbec06rNbbFWzI+HN9KDEfn3yTVg5697kM\nK3MYNgXJpcfwLeK0U2xe8wQdavYLcvdvUbD4puJFAoGAAb9fzuSvBAc78+N+FBpg\n8nzFTmkbQv3d0K3PstUXemHa19WKC7siIOlqoIo2QpOnZdzgiCpUyK4kWrxSvuuf\n+JmWXpLknjSQJuJOHZYTTzNFDQLWDGrImXfiYpWhrSGNp2j+BPgpZFAo4eyJcINj\nZH5POuhX3KF/E/xjw4IneX4=\n-----END PRIVATE KEY-----\n",
  "client_email": "bestreportertest@best-reporter-test.iam.gserviceaccount.com",
  "client_id": "113920177776050665181",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/bestreportertest%40best-reporter-test.iam.gserviceaccount.com"
  }
  ''';
  static final gSheets = GSheets(_credentials);
}