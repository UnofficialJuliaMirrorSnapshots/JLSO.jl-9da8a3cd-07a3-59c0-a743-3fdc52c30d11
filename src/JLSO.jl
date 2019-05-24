"""
A julia serialized object (JLSO) file format for storing checkpoint data.

# Structure

The .jlso files are BSON files containing the dictionaries with a specific schema.
NOTE: The raw dictionary should be loadable by any BSON library even if serialized objects
themselves aren't reconstructable.

Example)
```
Dict(
    "metadata" => Dict(
        "version" => v"1.0",
        "julia" => v"0.6.4",
        "format" => :bson,  # Could also be :serialize
        "image" => "xxxxxxxxxxxx.dkr.ecr.us-east-1.amazonaws.com/myrepository:latest"
        "pkgs" => Dict(
            "AxisArrays" => v"0.2.1",
            ...
        )
    ),
    "objects" => Dict(
        "var1" => [0x35, 0x10, 0x01, 0x04, 0x44],
        "var2" => [...],
    ),
)
```
WARNING: The serialized objects are stored using julia's builtin serialization format which
is not intended for long term storage. As a result, we're storing the serialized object data
in a json file which should also be able to load the docker image and versioninfo to allow
reconstruction.
"""
module JLSO

using BSON
using Serialization
using Memento
using Pkg

export JLSOFile

const LOGGER = getlogger(@__MODULE__)
const VALID_VERSIONS = (v"1.0", v"2.0")

__init__() = Memento.register(LOGGER)
include("JLSOFile.jl")
include("file_io.jl")
include("metadata.jl")
include("serialization.jl")

end  # module
