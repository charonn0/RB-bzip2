## Introduction
[BZip2](https://en.wikipedia.org/wiki/BZip2) is commonly used general purpose data compression algorithm. 

**RB-BZip2** is a BZip2 [binding](http://en.wikipedia.org/wiki/Language_binding) for Realbasic and Xojo projects.

## Hilights
* Read and write compressed file or memory streams using a simple [BinaryStream work-alike](https://github.com/charonn0/RB-bzip2/wiki/BZip2.BZ2Stream).

## Getting started
This project provides several different ways to use BZip2. 

### Utility methods
The easiest way to use this project are the utility methods in the BZip2 module: 

* [**`Compress`**](https://github.com/charonn0/RB-bzip2/wiki/BZip2.Compress)
* [**`Decompress`**](https://github.com/charonn0/RB-bzip2/wiki/BZip2.Decompress)

These methods are overloaded with several useful variations on input and output parameters. All variations follow either this signature:

```vbnet
 function(source, destination, options[...]) As Boolean
```
or this signature:
```vbnet
 function(source, options[...]) As MemoryBlock
```

where `source` is a `MemoryBlock`, `FolderItem`, or an object which implements the `Readable` interface; and `destination` (when provided) is a `FolderItem` or an object which implements the `Writeable` interface. Methods which do not have a `Destination` parameter return output as a `MemoryBlock` instead. Refer to the [examples](https://github.com/charonn0/RB-bzip2/wiki#more-examples) below for demonstrations of some of these functions.

### BZ2Stream class
The second way to use BZip2 is with the [`BZ2Stream`](https://github.com/charonn0/RB-bzip2/wiki/BZip2.BZ2Stream) class. The `BZ2Stream` is a `BinaryStream` work-alike, and implements both the `Readable` and `Writeable` interfaces. Anything [written](https://github.com/charonn0/RB-bzip2/wiki/BZip2.BZ2Stream.Write) to a `BZ2Stream` is compressed and emitted to the output stream (another `Writeable`); [reading](https://github.com/charonn0/RB-bzip2/wiki/BZip2.BZ2Stream.Read) from a `BZ2Stream` decompresses data from the input stream (another `Readable`).

Instances of `BZ2Stream` can be created from MemoryBlocks, FolderItems, and objects that implement the `Readable` and/or `Writeable` interfaces. For example, creating an in-memory compression stream from a zero-length MemoryBlock and writing a string to it:

```vbnet
  Dim output As New MemoryBlock(0)
  Dim z As New BZip2.BZ2Stream(output) ' zero-length creates a compressor
  z.Write("Hello, world!")
  z.Close
```
The string will be processed through the compressor and written to the `output` MemoryBlock. To create a decompressor pass a MemoryBlock whose size is > 0 (continuing from above):

```vbnet
  z = New BZip2.BZ2Stream(output) ' output contains the compressed string
  MsgBox(z.Read(64)) ' read the decompressed string
```

### Compressor and Decompressor classes
The third and final way to use this project is through the [Compressor](https://github.com/charonn0/RB-bzip2/wiki/BZip2.Compressor) and [Decompressor](https://github.com/charonn0/RB-bzip2/wiki/BZip2.Decompressor) classes. These classes provide a low-level wrapper to the BZip2 API. All compression and decompression done using the `BZ2Stream` class or the utility methods is ultimately carried out by an instance of `Compressor` and `Decompressor`, respectively.


## More examples
This example compresses and decompresses a MemoryBlock:
```vbnet
  Dim data As MemoryBlock = "Potentially very large MemoryBlock goes here!"
  Dim comp As MemoryBlock = BZip2.Compress(data)
  Dim dcmp As MemoryBlock = BZip2.Decompress(comp)
```

This example bzips a file:

```vbnet
  Dim src As FolderItem = GetOpenFolderItem("") ' a file to be bzipped
  Dim dst As FolderItem = src.Parent.Child(src.Name + ".bz2")
  If BZip2.Compress(src, dst) Then 
    MsgBox("Compression succeeded!")
  Else
    MsgBox("Compression failed!")
  End If
```

This example opens an existing bzip2 file and decompresses it into a `MemoryBlock`:
```vbnet
  Dim f As FolderItem = GetOpenFolderItem("") ' the bzip file to open
  Dim data As MemoryBlock = BZip2.Decompress(f)
  If data <> Nil Then
    MsgBox("Decompression succeeded!")
  Else
    MsgBox("Decompression failed!")
  End If
```

## How to incorporate bzip2 into your Realbasic/Xojo project
### Import the `BZip2` module
1. Download the RB-bzip2 project either in [ZIP archive format](https://github.com/charonn0/RB-bzip2/archive/master.zip) or by cloning the repository with your Git client.
2. Open the RB-bzip2 project in REALstudio or Xojo. Open your project in a separate window.
3. Copy the `BZip2` module into your project and save.

### Ensure the bzip2 shared library is installed
bzip2 is installed by default on many Unix-like operating systems, however it may need to be installed separately.

Windows does not have it installed by default, you will need to ship the DLL with your application. You can use pre-built DLL available [here](http://gnuwin32.sourceforge.net/packages/bzip2.htm) (Win32x86), or you can build them yourself from source: ftp://sources.redhat.com/pub/bzip2/v102/bzip2-1.0.2.tar.gz . 

RB-bzip2 will raise a PlatformNotSupportedException when used if all required DLLs/SOs/DyLibs are not available at runtime. 
