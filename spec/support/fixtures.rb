# frozen_string_literal: true

RSpec.shared_context("with fixtures") do
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
    "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImlMYVlEMFR2VjdP"\
      "LW16clFXeHhxTCJ9.eyJpc3MiOiJodHRwczovL2ZpcnN0Y2lyY2xlLWRldi5"\
      "ldS5hdXRoMC5jb20vIiwic3ViIjoiZ29vZ2xlLW9hdXRoMnwxMDE4NDM0NTk"\
      "5NjE3NjkyMjA5MDkiLCJhdWQiOlsiaHR0cHM6Ly9yYWlscy1hcGktYXV0aC1"\
      "zYW1wbGUuZmlyc3RjaXJjbGUuaW8iLCJodHRwczovL2ZpcnN0Y2lyY2xlLWR"\
      "ldi5ldS5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNjQ0MzEyNjcxLCJ"\
      "leHAiOjE2NDQzOTkwNzEsImF6cCI6IlFDQXYyQzRYWHJpd1BuelNYbENXYkc"\
      "5d2R2S05ZOUtwIiwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBlbWFpbCJ9.ZE"\
      "dnB_tNBquqPHgSa9GhUE8CPKCEcLybDaXcsGhxgOeIQfd1ei-uZ6E40NsERu"\
      "JyUVT9Sm8dy-gm9Mg9o-NdQmHVkBx53Cb3EV_3z8Jz4Yi9LNNbXW6SmIAs0q"\
      "hHBzQYFsnWilH6j0P9avVTEE0YwCPwht8La9YCMcPTQwknIKTxLFS_PdqQWX"\
      "BIlDhCJcQTc1pWm2U--M2cnnR2ghawxIEngp-gQrljMkAPANnf1L7EkSSFM1"\
      "5aahX1ckL-NetyhQyRTwggV35w-IvL11COQPCNtuCsMlT_VgqSM4np78g8xp"\
      "HYdj4SYY75GJbSTsBRPseRt9drxorUT5PGbrggDg"
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
