#tag Class
Protected Class ZipArchive
	#tag Method, Flags = &h0
		Sub AppendDirectory(DirectoryName As String)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AppendFile(File As FolderItem) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  If mArchive <> Nil Then mArchive.Close
		  mArchive = Nil
		  mDirectory = Nil
		  If mIterator <> Nil Then mIterator.Close
		  mIterator = Nil
		  If mZStream <> Nil Then mZStream.Close
		  mZStream = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor(ZipStream As BinaryStream, Directory As zlib.ZipHelpers.CentralDirectory)
		  mArchive = ZipStream
		  mZStream = ZStream.CreatePipe(mArchive, mArchive, Z_DEFAULT_COMPRESSION, Z_DEFAULT_STRATEGY, RAW_ENCODING)
		  mDirectory = Directory
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor(ZipStream As BinaryStream, Directory As zlib.ZipHelpers.Iterator)
		  mArchive = ZipStream
		  mZStream = ZStream.CreatePipe(mArchive, mArchive, Z_DEFAULT_COMPRESSION, Z_DEFAULT_STRATEGY, RAW_ENCODING)
		  mIterator = Directory
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  If mDirectory <> Nil Then
		    Return mDirectory.Count
		  ElseIf mIterator <> Nil Then
		    Call mIterator.Reset
		    Do Until Not mIterator.MoveNext(Nil)
		    Loop
		    Return mIterator.CurrentIndex + 1
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  Me.Close
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Extract(Index As Integer, WriteTo As FolderItem, Overwrite As Boolean = False) As Boolean
		  Return Extract(Index, BinaryStream.Create(WriteTo, Overwrite))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Extract(Index As Integer, WriteTo As Writeable) As Boolean
		  Dim f As zlib.ZipHelpers.ZipEntry = Me.Item(Index)
		  mArchive.Position = f.Offset
		  'Try
		  WriteTo.Write(mZStream.Read(f.CompressedSize))
		  'Catch
		  'Return False
		  'End Try
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Flush()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Item(Index As Integer) As zlib.ZipHelpers.ZipEntry
		  If mDirectory <> Nil Then
		    Return mDirectory.Item(Index)
		  ElseIf mIterator <> Nil Then
		    Call mIterator.Reset
		    For i As Integer = 0 To Index - 1
		      Call mIterator.MoveNext(Nil)
		    Next
		    Return mIterator.CurrentItem
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Open(ZipStream As BinaryStream, RepairMode As Boolean = False) As zlib.ZipArchive
		  If RepairMode Then
		    Return New ZipArchive(ZipStream, New zlib.ZipHelpers.Iterator(ZipStream))
		  Else
		    Return New ZipArchive(ZipStream, New zlib.ZipHelpers.CentralDirectory(ZipStream))
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Open(ZipFile As FolderItem, RepairMode As Boolean = False) As zlib.ZipArchive
		  Return Open(BinaryStream.Open(ZipFile, True), RepairMode)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Reload(RepairMode As Boolean = False) As Boolean
		  mDirectory = Nil
		  mIterator = Nil
		  mArchive.Position = 0
		  If mZStream <> Nil Then mZStream.Close
		  mZStream = Nil
		  If Not RepairMode Then
		    mDirectory = New zlib.ZipHelpers.CentralDirectory(mArchive)
		  Else
		    mIterator = New zlib.ZipHelpers.Iterator(mArchive)
		  End If
		  mZStream = ZStream.CreatePipe(mArchive, mArchive, Z_DEFAULT_COMPRESSION, Z_DEFAULT_STRATEGY, RAW_ENCODING)
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mArchive As BinaryStream
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDirectory As zlib.ZipHelpers.CentralDirectory
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mIterator As zlib.ZipHelpers.Iterator
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mZStream As zlib.ZStream
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
