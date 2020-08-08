#tag Module
Protected Module BZip2
	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BZ2_bzCompress Lib libbzip2 (ByRef Stream As bz_stream, Action As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BZ2_bzCompressEnd Lib libbzip2 (ByRef Stream As bz_stream) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BZ2_bzCompressInit Lib libbzip2 (ByRef Stream As bz_stream, BlockSize100k As Integer, Verbosity As Integer, WorkFactor As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BZ2_bzDecompress Lib libbzip2 (ByRef Stream As bz_stream) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BZ2_bzDecompressEnd Lib libbzip2 (ByRef Stream As bz_stream) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BZ2_bzDecompressInit Lib libbzip2 (ByRef Stream As bz_stream, Verbosity As Integer, Small As Integer) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BZ2_bzlibVersion Lib libbzip2 () As Ptr
	#tag EndExternalMethod

	#tag Method, Flags = &h1
		Protected Function Compress(Source As FolderItem, Destination As FolderItem, CompressionLevel As Integer = BZip2.BZ_DEFAULT_COMPRESSION, Overwrite As Boolean = False) As Boolean
		  ' Compress the Source file into the Destination file.
		  
		  Dim dst As BinaryStream = BinaryStream.Create(Destination, Overwrite)
		  Dim src As BinaryStream = BinaryStream.Open(Source)
		  Dim ok As Boolean
		  Try
		    ' calls Compress(Readable, Writeable, Integer) As Boolean
		    ok = Compress(src, dst, CompressionLevel)
		  Finally
		    src.Close
		    dst.Close
		  End Try
		  Return ok
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Compress(Source As FolderItem, CompressionLevel As Integer = BZip2.BZ_DEFAULT_COMPRESSION) As MemoryBlock
		  ' Compress the Source file and return it.
		  
		  Dim buffer As New MemoryBlock(0)
		  Dim dst As New BinaryStream(buffer)
		  Dim src As BinaryStream = BinaryStream.Open(Source)
		  Dim ok As Boolean
		  Try
		    ' calls Compress(Readable, Writeable, Integer) As Boolean
		    ok = Compress(src, dst, CompressionLevel)
		  Finally
		    src.Close
		    dst.Close
		  End Try
		  If ok Then Return buffer
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Compress(Source As FolderItem, Destination As Writeable, CompressionLevel As Integer = BZip2.BZ_DEFAULT_COMPRESSION) As Boolean
		  ' Compress the Source file into the Destination stream. 
		  
		  Dim src As BinaryStream = BinaryStream.Open(Source)
		  Dim ok As Boolean
		  Try
		    ' calls Compress(Readable, Writeable, Integer) As Boolean
		    ok = Compress(src, Destination, CompressionLevel)
		  Finally
		    src.Close
		  End Try
		  Return ok
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Compress(Source As MemoryBlock, Destination As FolderItem, CompressionLevel As Integer = BZip2.BZ_DEFAULT_COMPRESSION, Overwrite As Boolean = False) As Boolean
		  ' Compress the Source data into the Destination file. 
		  
		  Dim dst As BinaryStream = BinaryStream.Create(Destination, Overwrite)
		  Dim ok As Boolean
		  Try
		    ' calls Compress(MemoryBlock, Writeable, Integer) As Boolean
		    ok = Compress(Source, dst, CompressionLevel)
		  Finally
		    dst.Close
		  End Try
		  Return ok
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Compress(Source As MemoryBlock, CompressionLevel As Integer = BZip2.BZ_DEFAULT_COMPRESSION) As MemoryBlock
		  ' Compress the Source data and return it. 
		  
		  Dim buffer As New MemoryBlock(0)
		  Dim dst As New BinaryStream(buffer)
		  Dim src As New BinaryStream(Source)
		  ' calls Compress(Readable, Writeable, Integer) As Boolean
		  If Not Compress(src, dst, CompressionLevel) Then Return Nil
		  dst.Close
		  Return buffer
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Compress(Source As MemoryBlock, Destination As Writeable, CompressionLevel As Integer = BZip2.BZ_DEFAULT_COMPRESSION) As Boolean
		  ' Compress the Source data into the Destination stream. 
		  
		  Dim src As New BinaryStream(Source)
		  ' calls Compress(Readable, Writeable, Integer) As Boolean
		  Return Compress(src, Destination, CompressionLevel)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Compress(Source As Readable, Destination As FolderItem, CompressionLevel As Integer = BZip2.BZ_DEFAULT_COMPRESSION, Overwrite As Boolean = False) As Boolean
		  ' Compress the Source stream into the Destination file.
		  
		  Dim dst As BinaryStream = BinaryStream.Create(Destination, Overwrite)
		  Dim ok As Boolean
		  Try
		    ' calls Compress(Readable, Writeable, Integer) As Boolean
		    ok = Compress(Source, dst, CompressionLevel)
		  Finally
		    dst.Close
		  End Try
		  Return ok
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Compress(Source As Readable, CompressionLevel As Integer = BZip2.BZ_DEFAULT_COMPRESSION) As MemoryBlock
		  ' Compress the Source stream and return it. 
		  
		  Dim buffer As New MemoryBlock(0)
		  Dim stream As New BinaryStream(buffer)
		  ' calls Compress(Readable, Writeable, Integer) As Boolean
		  If Not Compress(Source, stream, CompressionLevel) Then Return Nil
		  stream.Close
		  Return buffer
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Compress(Source As Readable, Destination As Writeable, CompressionLevel As Integer = BZip2.BZ_DEFAULT_COMPRESSION) As Boolean
		  ' Compress the Source stream and write the output to the Destination stream. Use Decompress to reverse.
		  
		  Dim bz As BZ2Stream = BZ2Stream.Create(Destination, CompressionLevel)
		  Try
		    Do Until Source.EOF
		      bz.Write(Source.Read(CHUNK_SIZE))
		    Loop
		    bz.Close
		  Catch
		    Return False
		  End Try
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Decompress(Source As FolderItem) As MemoryBlock
		  ' Decompress the Source file and return it.
		  
		  Dim buffer As New MemoryBlock(0)
		  Dim dst As New BinaryStream(buffer)
		  Dim src As BinaryStream = BinaryStream.Open(Source)
		  Dim ok As Boolean
		  Try
		    ' calls Decompress(Readable, Writeable) As Boolean
		    ok = Decompress(src, dst)
		  Finally
		    src.Close
		    dst.Close
		  End Try
		  If ok Then Return buffer
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Decompress(Source As FolderItem, Destination As FolderItem, Overwrite As Boolean = False) As Boolean
		  ' Decompress the Source file and write the output to the Destination file. 
		  
		  Dim dst As BinaryStream = BinaryStream.Create(Destination, Overwrite)
		  Dim src As BinaryStream = BinaryStream.Open(Source)
		  Dim ok As Boolean
		  Try
		    ' calls Decompress(Readable, Writeable) As Boolean
		    ok = Decompress(src, dst)
		  Finally
		    src.Close
		    dst.Close
		  End Try
		  Return ok
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Decompress(Source As FolderItem, Destination As Writeable) As Boolean
		  ' Decompresses the Source file into the Destination stream.
		  
		  Dim src As BinaryStream = BinaryStream.Open(Source)
		  Dim ok As Boolean
		  Try
		    ' calls Decompress(Readable, Writeabler) As Boolean
		    ok = Decompress(src, Destination)
		  Finally
		    src.Close
		  End Try
		  Return ok
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Decompress(Source As MemoryBlock) As MemoryBlock
		  ' Decompress the Source data and return it.
		  
		  Dim src As New BinaryStream(Source)
		  ' calls Decompress(Readable) As MemoryBlock
		  Return Decompress(src)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Decompress(Source As MemoryBlock, Destination As FolderItem, Overwrite As Boolean = False) As Boolean
		  ' Decompress the Source data into the Destination file.
		  
		  Dim dst As BinaryStream = BinaryStream.Create(Destination, Overwrite)
		  Dim src As New BinaryStream(Source)
		  Dim ok As Boolean
		  Try
		    ' calls Decompress(Readable, Writeable) As Boolean
		    ok = Decompress(src, dst)
		  Finally
		    src.Close
		    dst.Close
		  End Try
		  Return ok
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Decompress(Source As MemoryBlock, Destination As Writeable) As Boolean
		  ' Decompress the Source data into the Destination stream.
		  
		  Dim src As New BinaryStream(Source)
		  Dim ok As Boolean
		  Try
		    ' calls Decompress(Readable, Writeable) As Boolean
		    ok = Decompress(src, Destination)
		  Finally
		    src.Close
		  End Try
		  Return ok
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Decompress(Source As Readable) As MemoryBlock
		  ' Decompress the Source stream and return it.
		  
		  Dim buffer As New MemoryBlock(0)
		  Dim stream As New BinaryStream(buffer)
		  ' calls Decompress(Readable, Writeable) As Boolean
		  If Not Decompress(Source, stream) Then Return Nil
		  stream.Close
		  Return buffer
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Decompress(Source As Readable, Destination As FolderItem, Overwrite As Boolean = False) As Boolean
		  ' Decompress the Source stream into the Destination file.
		  
		  Dim dst As BinaryStream = BinaryStream.Create(Destination, Overwrite)
		  Dim ok As Boolean
		  Try
		    ' calls Decompress(Readable, Writeable) As Boolean
		    ok = Decompress(Source, dst)
		  Finally
		    dst.Close
		  End Try
		  Return ok
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Decompress(Source As Readable, Destination As Writeable) As Boolean
		  ' Decompress the Source stream and write the output to the Destination stream.
		  
		  Dim bz As BZ2Stream = BZ2Stream.Open(Source)
		  Try
		    bz.BufferedReading = False
		    Do Until bz.EOF
		      Dim data As MemoryBlock = bz.Read(CHUNK_SIZE)
		      If data <> Nil And data.Size > 0 Then Destination.Write(Data)
		    Loop
		    bz.Close
		  Catch
		    Return False
		  End Try
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function IsAvailable() As Boolean
		  Static mIsAvailable As Boolean
		  
		  If Not mIsAvailable Then mIsAvailable = System.IsFunctionAvailable("BZ2_bzCompressInit", libbzip2)
		  Return mIsAvailable
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IsBZipped(Extends Target As BinaryStream) As Boolean
		  //Checks the BZ2 magic number. Returns True if the Target is likely a BZ2 stream
		  
		  Dim IsBZ2 As Boolean
		  Dim pos As UInt64 = Target.Position
		  If Target.Read(3) = "BZh" Then IsBZ2 = True 'maybe
		  Target.Position = pos
		  Return IsBZ2
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsBZipped(Extends TargetFile As FolderItem) As Boolean
		  //Checks the BZ2 magic number. Returns True if the TargetFile is likely a BZ2 stream
		  
		  If Not TargetFile.Exists Then Return False
		  If TargetFile.Directory Then Return False
		  Dim bs As BinaryStream
		  Dim IsBZ2 As Boolean
		  Try
		    bs = BinaryStream.Open(TargetFile)
		    IsBZ2 = bs.IsBZipped()
		  Catch
		    IsBZ2 = False
		  Finally
		    If bs <> Nil Then bs.Close
		  End Try
		  Return IsBZ2
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsBZipped(Extends Target As MemoryBlock) As Boolean
		  //Checks the BZ2 magic number. Returns True if the Target is likely a BZ2 stream
		  
		  If Target.Size = -1 Then Return False
		  Dim bs As BinaryStream
		  Dim IsBZ2 As Boolean
		  Try
		    bs = New BinaryStream(Target)
		    IsBZ2 = bs.IsBZipped()
		  Catch
		    IsBZ2 = False
		  Finally
		    If bs <> Nil Then bs.Close
		  End Try
		  Return IsBZ2
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Version() As String
		  If Not BZip2.IsAvailable Then Return ""
		  Dim mb As MemoryBlock = BZ2_bzlibVersion()
		  Return mb.CString(0)
		End Function
	#tag EndMethod


	#tag Note, Name = Copying
		RB-BZip2 (https://github.com/charonn0/RB-BZip2)
		
		Copyright (c)2018-19 Andrew Lambert, all rights reserved.
		
		 Permission to use, copy, modify, and distribute this software for any purpose
		 with or without fee is hereby granted, provided that the above copyright
		 notice and this permission notice appear in all copies.
		 
		    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY RIGHTS. IN
		    NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
		    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
		    OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
		    OR OTHER DEALINGS IN THE SOFTWARE.
		 
		 Except as contained in this notice, the name of a copyright holder shall not
		 be used in advertising or otherwise to promote the sale, use or other dealings
		 in this Software without prior written authorization of the copyright holder.
	#tag EndNote


	#tag Constant, Name = BZ_CONFIG_ERROR, Type = Double, Dynamic = False, Default = \"-9", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_DATA_ERROR, Type = Double, Dynamic = False, Default = \"-4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_DATA_ERROR_MAGIC, Type = Double, Dynamic = False, Default = \"-5", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_DEFAULT_COMPRESSION, Type = Double, Dynamic = False, Default = \"6", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BZ_FINISH, Type = Double, Dynamic = False, Default = \"2", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BZ_FINISH_OK, Type = Double, Dynamic = False, Default = \"3", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_FLUSH, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BZ_FLUSH_OK, Type = Double, Dynamic = False, Default = \"2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_IO_ERROR, Type = Double, Dynamic = False, Default = \"-6", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_MEM_ERROR, Type = Double, Dynamic = False, Default = \"-3", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_OK, Type = Double, Dynamic = False, Default = \"0", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_OUTBUFF_FULL, Type = Double, Dynamic = False, Default = \"-8", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_PARAM_ERROR, Type = Double, Dynamic = False, Default = \"-2", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_RUN, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BZ_RUN_OK, Type = Double, Dynamic = False, Default = \"1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_SEQUENCE_ERROR, Type = Double, Dynamic = False, Default = \"-1", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_STREAM_END, Type = Double, Dynamic = False, Default = \"4", Scope = Private
	#tag EndConstant

	#tag Constant, Name = BZ_UNEXPECTED_EOF, Type = Double, Dynamic = False, Default = \"-7", Scope = Private
	#tag EndConstant

	#tag Constant, Name = CHUNK_SIZE, Type = Double, Dynamic = False, Default = \"16384", Scope = Private
	#tag EndConstant

	#tag Constant, Name = libbzip2, Type = String, Dynamic = False, Default = \"libbz2.so.1", Scope = Private
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"libbz2.dll"
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"/usr/lib/libbz2.dylib"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"libbz2.so.1"
	#tag EndConstant


	#tag Structure, Name = bz_stream, Flags = &h21
		Next_In As Ptr
		  Avail_In As UInt32
		  Total_In_Low As UInt32
		  Total_In_High As UInt32
		  Next_Out As Ptr
		  Avail_Out As UInt32
		  Total_Out_Low As UInt32
		  Total_Out_High As UInt32
		  State As Ptr
		  Alloc As Ptr
		  Free As Ptr
		Opaque As Ptr
	#tag EndStructure


End Module
#tag EndModule
