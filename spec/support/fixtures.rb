# frozen_string_literal: true

RSpec.shared_context("with fixtures") do
  let(:auth0_admin_user_model) { AdminUser }
  let(:auth0_admin_user_email) do
    Faker::Internet.unique.email(domain: auth0_admin_user_model.auth0_config.email_domains_allowlist.sample)
  end
  let(:auth0_admin_user) do
    uid = Faker::Internet.unique.uuid

    auth0_admin_user_model.create(
      provider: "auth0",
      uid: uid,
      email: auth0_admin_user_email,
      password: "password"
    )
  end

  let(:auth0_user_model) { User }
  let(:auth0_user) do
    uid = Faker::Internet.unique.uuid

    auth0_user_model.create(
      provider: "auth0",
      uid: uid,
      email: Faker::Internet.unique.email,
      password: "password"
    )
  end

  let(:jwt_token) do
    "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ikl4aTdVSHdURGhWO"\
      "FpJWmFJNnNFUyJ9.eyJpc3MiOiJodHRwczovL2F1dGgudGVzdC5maXJzdGNp"\
      "cmNsZS5waC8iLCJzdWIiOiJnb29nbGUtb2F1dGgyfDEwMTg0MzQ1OTk2MTc2"\
      "OTIyMDkwOSIsImF1ZCI6WyJodHRwczovL3N0YWdpbmctdC5hcGkuY29ubmVj"\
      "dC5maXJzdGNpcmNsZS5waCIsImh0dHBzOi8vZmlyc3RjaXJjbGUtdGVzdC5l"\
      "dS5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNjQ2OTc1OTU0LCJleHAi"\
      "OjE2NDgyNzE5NTQsImF6cCI6IjlsSkZUelY3UjdSZHNVdmVmdHNHdkJkancz"\
      "SWQwend0Iiwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBlbWFpbCIsInBlcm1p"\
      "c3Npb25zIjpbXX0.v_paPUZg6Ocz5_d79gwPxfgp2xt4aWLDATNZWL3Fmmix"\
      "MXR-gkMYCSTNrivoqCXEYQiL_fL2mmW0IvARMI7BNoh5ezfkpmm8kHxELKRX"\
      "QWJLshp7FMnTir1d2s1WW0CJ82fSC5r1-RtdsguUnWuomBUHik_oKX7ZN_iz"\
      "M2jP9zBStuThBpT5ZGHEticeXZS4T1p6j_mZF9jYKJP1GdhjE2mBgpxNU0dl"\
      "w_oVKsJpVud0TjeKqtd72LS8vMOTzE_N0eefniscVg3wlyYCe8wnB48zdhvb"\
      "9AihcIwwUt_eNre6YHvxl_oBcg38WdN0FXkZay3vx2o1JfYO-wnH3HFnBA"
  end
  let(:client_token) do
    "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImlMYVlEMFR2VjdPL"\
      "W16clFXeHhxTCJ9.eyJpc3MiOiJodHRwczovL2ZpcnN0Y2lyY2xlLWRldi5ld"\
      "S5hdXRoMC5jb20vIiwic3ViIjoiVUR1eVJDNlhlVnI5ZUNQSXJPUDBkZ0lMMH"\
      "hUTHMzM2ZAY2xpZW50cyIsImF1ZCI6Imh0dHBzOi8vcmFpbHMtYXBpLWF1dGg"\
      "tc2FtcGxlLmZpcnN0Y2lyY2xlLmlvIiwiaWF0IjoxNjQ0MzQyMjQ2LCJleHAi"\
      "OjE2NDQ0Mjg2NDYsImF6cCI6IlVEdXlSQzZYZVZyOWVDUElyT1AwZGdJTDB4V"\
      "ExzMzNmIiwic2NvcGUiOiJyZWFkOmxlYWRzIiwiZ3R5IjoiY2xpZW50LWNyZW"\
      "RlbnRpYWxzIn0.HRMF3isTmjFbHpYMZMVfPYFf89VISi-39ve7OEjQhxK_NoN"\
      "uc6UVJq76vw5qrxrKIed2jO7bx-FIEE9IYKTCv13EglDRDs7iwsOl2jDFtgeX"\
      "6x6C2UehEq649g_7J4pjU1jrVWXfbfLsTL1HZ9Gd320iBvHyhOm_s6WHRHEBn"\
      "4cYccrbik7VSPq9mYMVElPu2E3_lFTGHmFFiyPPbDxqaPzpChgkhEfggJFOMQ"\
      "hCiGnqyPrRHDWXdBxKK57Is7IIGaIIjz_gnSX8oWy2B2jpEzbG53pNAJn9ubo"\
      "48tAQvJkgZCoY-b6nKH9QBD3c2oCSk2cqgh1jcGI01j9O1lgyYQ"
  end
end
