#tag Class
Protected Class ZipEntry
	#tag Method, Flags = &h0
		Sub Constructor(Header As ZipDirectoryHeader, FileName As String, ExtraData As MemoryBlock, Comment As String)
		  mZipDirectoryHeader = Header
		  mName = FileName
		  mExtra = ExtraData
		  mIsAFileHeader = False
		  mOffset = mZipDirectoryHeader.Offset
		  mComment = Comment
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(Header As ZipFileHeader, FileName As String, ExtraData As MemoryBlock, DataOffset As UInt64)
		  mZipFileHeader = Header
		  mName = FileName
		  mExtra = ExtraData
		  mIsAFileHeader = True
		  mOffset = DataOffset
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mComment
			End Get
		#tag EndGetter
		Comment As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mIsAFileHeader Then
			    Return mZipFileHeader.CompressedSize
			  Else
			    Return mZipDirectoryHeader.CompressedSize
			  End If
			End Get
		#tag EndGetter
		CompressedSize As UInt64
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mIsAFileHeader Then
			    Return mZipFileHeader.CRC32
			  Else
			    Return mZipDirectoryHeader.CRC32
			  End If
			End Get
		#tag EndGetter
		CRC32 As UInt32
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mExtra
			End Get
		#tag EndGetter
		ExtraData As MemoryBlock
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return mName
			End Get
		#tag EndGetter
		FileName As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mIsAFileHeader Then
			    Return mZipFileHeader.Flag
			  Else
			    Return mZipDirectoryHeader.Flag
			  End If
			End Get
		#tag EndGetter
		Flag As UInt16
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mComment As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mIsAFileHeader Then
			    Return mZipFileHeader.Method
			  Else
			    Return mZipDirectoryHeader.Method
			  End If
			End Get
		#tag EndGetter
		Method As UInt16
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mExtra As MemoryBlock
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mIsAFileHeader As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mName As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Dim dt, tm As UInt16
			  If mIsAFileHeader Then
			    dt = mZipFileHeader.ModDate
			    tm = mZipFileHeader.ModTime
			  Else
			    dt = mZipDirectoryHeader.ModDate
			    tm = mZipDirectoryHeader.ModTime
			  End If
			  
			  Return ConvertDate(dt, tm)
			End Get
		#tag EndGetter
		ModificationDate As Date
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected mOffset As UInt64
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mZipDirectoryHeader As ZipDirectoryHeader
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mZipFileHeader As ZipFileHeader
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mIsAFileHeader Then
			    Return mZipFileHeader.UncompressedSize
			  Else
			    Return mZipDirectoryHeader.UncompressedSize
			  End If
			End Get
		#tag EndGetter
		UncompressedSize As UInt64
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mIsAFileHeader Then
			    Return mZipFileHeader.Version
			  Else
			    Return mZipDirectoryHeader.Version
			  End If
			End Get
		#tag EndGetter
		Version As UInt16
	#tag EndComputedProperty


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
