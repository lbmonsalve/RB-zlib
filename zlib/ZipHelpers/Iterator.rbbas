#tag Class
Protected Class Iterator
	#tag Method, Flags = &h0
		Sub Constructor(ZipStream As BinaryStream)
		  mFileStream = ZipStream
		  mFileStream.LittleEndian = True
		  If Not Me.Reset(0) Then Raise New zlibException(ERR_NOT_ZIPPED)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CurrentIndex() As Integer
		  Return mCurrentIndex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CurrentItem() As ZipEntry
		  Return mCurrentItem
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function MoveNext(WriteTo As Writeable) As Boolean
		  If mCurrentItem <> Nil Then
		    If WriteTo <> Nil Then
		      WriteTo.Write(mFileStream.Read(mCurrentItem.CompressedSize))
		    Else
		      mFileStream.Position = mFileStream.Position + mCurrentItem.CompressedSize
		    End If
		  End If
		  
		  Select Case mFileStream.ReadUInt32
		  Case FILE_SIGNATURE 
		    mFileStream.Position = mFileStream.Position - 4
		    Dim header As ZipFileHeader
		    header.StringValue(True) = mFileStream.Read(header.Size)
		    Dim name As String = mFileStream.Read(header.FilenameLength)
		    Dim extra As MemoryBlock = mFileStream.Read(header.ExtraLength)
		    mCurrentItem = New ZipEntry(header, name, extra, mFileStream.Position)
		  Case DIRECTORY_SIGNATURE
		    mLastError = ERR_END_ARCHIVE
		  Else
		    mLastError = ERR_INVALID_ENTRY
		  End Select
		  Return mLastError = 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Reset(Index As Integer = 0) As Boolean
		  mFileStream.Position = 0
		  mCurrentIndex = 0
		  mCurrentItem = Nil
		  Do Until mCurrentIndex >= Index And Index > -1
		    If Not Me.MoveNext(Nil) Then Return (Index = -1 And mLastError = ERR_END_ARCHIVE)
		  Loop
		  Return True
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected mCurrentIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mCurrentItem As ZipEntry
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mFileStream As BinaryStream
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
