using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace MMS.API
{
    public static class Encryption
    {
        const string Salt = "PrIvAtEkEYmMs";
        public static byte[] GetHashKey(string hashKey)
        {
            // Initialize
            var encoder = new UTF8Encoding();
            // Get the salt
            var saltBytes = encoder.GetBytes(Salt);
            // Setup the hasher
            var rfc = new Rfc2898DeriveBytes(hashKey, saltBytes);
            // Return the key
            return rfc.GetBytes(16);
        }
        public static string Encrypt(byte[] key, string dataToEncrypt)
        {
            // Initialize
            var encryptor = new AesManaged()
            {
                // Set the key
                Key = key,
                IV = key
            };
            // create a memory stream
            using (var encryptionStream = new MemoryStream())
            {
                // Create the crypto stream
                using (var encrypt = new CryptoStream(encryptionStream, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                {
                    // Encrypt
                    var utfD1 = Encoding.UTF8.GetBytes(dataToEncrypt);
                    encrypt.Write(utfD1, 0, utfD1.Length);
                    encrypt.FlushFinalBlock();
                    encrypt.Close();
                    // Return the encrypted data
                    return Convert.ToBase64String(encryptionStream.ToArray());
                }
            }
        }
        public static string Decrypt(byte[] key, string encryptedString)
        {
            // Initialize
            var decryptor = new AesManaged();
            var encryptedData = Convert.FromBase64String(encryptedString);
            // Set the key
            decryptor.Key = key;
            decryptor.IV = key;
            // create a memory stream
            using (var decryptionStream = new MemoryStream())
            {
                // Create the crypto stream
                using (var decrypt = new CryptoStream(decryptionStream, decryptor.CreateDecryptor(), CryptoStreamMode.Write))
                {
                    // Encrypt
                    decrypt.Write(encryptedData, 0, encryptedData.Length);
                    decrypt.Flush();
                    decrypt.Close();
                    // Return the unencrypted data
                    var decryptedData = decryptionStream.ToArray();
                    return Encoding.UTF8.GetString(decryptedData, 0, decryptedData.Length);
                }
            }
        }
    }
}