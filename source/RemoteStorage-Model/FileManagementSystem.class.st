Class {
	#name : #FileManagementSystem,
	#superclass : #SubsystemImplementation,
	#instVars : [
		'files'
	],
	#category : #'RemoteStorage-Model-Core'
}

{ #category : #installing }
FileManagementSystem >> dependencies [
	^ #()
]

{ #category : #initialization }
FileManagementSystem >> ensureRemoteStorageDirectoryExists [
	self remoteStorageDirectoryReference ensureCreateDirectory
]

{ #category : #initialization }
FileManagementSystem >> getAllFiles [
	self updateFiles.
	^ files
]

{ #category : #installing }
FileManagementSystem >> implementedInterfaces [
	^ #(#FileManagementSystemInterface)
]

{ #category : #initialization }
FileManagementSystem >> initialize [
	super initialize.
	self
		ensureRemoteStorageDirectoryExists;
		initializeFiles
]

{ #category : #initialization }
FileManagementSystem >> initializeFiles [

	files := (self remoteStorageDirectoryReference allFiles
		collect: [ :file | RSFile from: file ]) asOrderedCollection
]

{ #category : #accessing }
FileManagementSystem >> name [
	^ 'Sistema de manejo de archivos'
]

{ #category : #initialization }
FileManagementSystem >> remoteStorageDirectoryReference [
	^ (Path from: './' , self remoteStorageFolderName) asFileReference
]

{ #category : #initialization }
FileManagementSystem >> remoteStorageFolderName [
	^ 'RSFiles'
]

{ #category : #initialization }
FileManagementSystem >> updateFiles [

	self remoteStorageDirectoryReference allFiles
		do: [ :file | 
			((files collect: #name)
				anySatisfy: [ :fileName | fileName = file pathSegments last ])
				ifFalse: [ files add: (RSFile from: file) ] ]
]

{ #category : #initialization }
FileManagementSystem >> writeFileNamed: aName withExtention: anExtention withContents: aByteArray [
	| newFileRelativePath |
	newFileRelativePath := self remoteStorageFolderName , '/' , aName
		, '.' , anExtention.
	FileStream
		newFileNamed: newFileRelativePath
		do: [ :fileStream | 
			fileStream
				nextPutAll: aByteArray;
				close ].
	^ RSFile
		from: (Path from: './' , newFileRelativePath) asFileReference
]
