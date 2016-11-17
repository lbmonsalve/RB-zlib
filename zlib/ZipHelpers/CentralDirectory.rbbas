#tag Class
Protected Class CentralDirectory
	#tag Method, Flags = &h0
		Sub Constructor(ZipStream As BinaryStream)
		  mFileStream = ZipStream
		  mFileStream.LittleEndian = True
		  ' locate the directory footer by reading backwards from the end 
		  mFileStream.Position = mFileStream.Length - 4
		  Do Until mDirectoryOffset > 0
		    If mFileStream.ReadUInt32 = DIRECTORY_FOOTER_HEADER Then
		      mFileStream.Position = mFileStream.Position - 4
		      mDirectoryLength = mFileStream.Position ' store the end position
		      mDirectoryFooter.StringValue(True) = mFileStream.Read(mDirectoryFooter.Size)
		      mFileStream.Position = mDirectoryFooter.Offset
		      mDirectoryOffset = mFileStream.Position
		    Else
		      mFileStream.Position = mFileStream.Position - 5
		    End If
		  Loop Until mFileStream.Position < 22
		  If mDirectoryOffset = 0 Then Raise New zlibException(ERR_NOT_ZIPPED)
		  mDirectoryLength = mDirectoryLength - mDirectoryOffset
		  Me.Reload()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  Return mDirectoryFooter.ThisRecordCount
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Item(Index As Integer) As ZipEntry
		  Return mEntries(Index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reload()
		  mFileStream.Position = mDirectoryOffset ' move the file pointer to the beginning of the directory
		  ReDim mEntries(-1)
		  Do
		    Dim entry As ZipDirectoryHeader
		    entry.StringValue(True) = mFileStream.Read(entry.Size)
		    
		    If entry.Signature <> DIRECTORY_SIGNATURE Then Raise New zlibException(ERR_INVALID_ENTRY)
		    
		    Dim name As String = mFileStream.Read(entry.FilenameLength)
		    Dim extra As MemoryBlock = mFileStream.Read(entry.ExtraLength)
		    Dim comment As String = mFileStream.Read(entry.CommentLength)
		    mEntries.Append(New ZipEntry(entry, name, extra, comment))
		  Loop Until mFileStream.Position >= mDirectoryOffset + mDirectoryLength
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mDirectoryFooter As ZipDirectoryFooter
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDirectoryLength As UInt64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mDirectoryOffset As UInt64
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mEntries() As ZipEntry
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFileStream As BinaryStream
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mLastError As Integer
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
