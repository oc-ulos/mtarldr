print("This program was run from inside a MTAR.")
print("Arguments:", ...)

print("Contents of MTAR /:")
print(table.unpack(mtarfs.list("/")))
