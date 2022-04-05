mutable struct 模具<:Item
	shape::Symbol
	mat::Material
end
id(i::模具)="$(i.mat)质$(i.shape)模具"
