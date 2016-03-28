require 'torch'
require 'nn'

local CROP_SIZE = 128

local model = nn.Sequential()

local concat = nn.ParallelTable()
local rgb = nn.Sequential()
local d = nn.Sequential()

rgb:add(nn.Dropout())

rgb:add(nn.SpatialConvolution(3, 32, 3, 3, 1, 1, 1, 1))
rgb:add(nn.ReLU(true))

rgb:add(nn.Dropout())
rgb:add(nn.SpatialConvolution(32, 64, 3, 3, 2, 2, 1, 1))
rgb:add(nn.ReLU(true))

rgb:add(nn.Dropout())
rgb:add(nn.SpatialConvolution(64, 128, 3, 3, 2, 2, 1, 1))
rgb:add(nn.ReLU(true))

rgb:add(nn.Dropout())
rgb:add(nn.SpatialConvolution(128, 64, 3, 3, 2, 2, 1, 1))
rgb:add(nn.ReLU(true))

concat:add(rgb)

d:add(nn.Dropout())

d:add(nn.SpatialConvolution(1, 32, 3, 3, 1, 1, 1, 1))
d:add(nn.ReLU(true))

rgb:add(nn.Dropout())
d:add(nn.SpatialConvolution(32, 64, 3, 3, 2, 2, 1, 1))
d:add(nn.ReLU(true))

rgb:add(nn.Dropout())
d:add(nn.SpatialConvolution(64, 128, 3, 3, 2, 2, 1, 1))
d:add(nn.ReLU(true))

rgb:add(nn.Dropout())
d:add(nn.SpatialConvolution(128, 64, 3, 3, 2, 2, 1, 1))
d:add(nn.ReLU(true))

concat:add(d)
model:add(concat)
model:add(nn.JoinTable(1, 3))
model:add(nn.Reshape(16*16*128))
model:add(nn.Linear(16*16*128, 2))

return model
