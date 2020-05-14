using Test
using PolygonArea
using PolygonArea: PolarHalfPlane, Point, corner, Intersection, Reunion
using PolygonArea: outward_normal, rotate, translate, distance
using StaticArrays

inferior_hp = HalfPlane(0, 1, 0)
@test Point(0, -1) in inferior_hp
@test Point(0, 0) in inferior_hp
@test !(Point(0, 1) in inferior_hp)

right_hp = HalfPlane(-1, 0, 0)
@test Point(1, 0) in right_hp
@test !(Point(-1, 0) in right_hp)

@test Point(1, -1) in intersect(inferior_hp, right_hp)
@test Point(1, -1) in inferior_hp ∩ right_hp
@test !(Point(1, 1) in intersect(inferior_hp, right_hp))
@test Point(1, 1) in invert(intersect(inferior_hp, right_hp))

@test !(Point(-1, 1) in union(inferior_hp, right_hp))
@test (Point(1, 1) in union(inferior_hp, right_hp))

@test PolygonArea.corner(inferior_hp, right_hp) == @SVector [0.0, 0.0]
@test PolygonArea.corner(HalfPlane(1, 0, 1), HalfPlane(0, -1, 0.5)) == @SVector [-1.0, 0.5]

@test PolygonArea.distance(Point(9.0, 0.0), PolarHalfPlane(0.0, 0.0)) ≈ 9.0
@test PolygonArea.distance(Point(9.0, 0.0), PolarHalfPlane(1.0, 0.0)) ≈ 10.0
@test PolygonArea.distance(Point(9.0, -10.0), PolarHalfPlane(1.0, 0.0)) ≈ 10.0
@test PolygonArea.distance(Point(9.0, 1.0), PolarHalfPlane(0.0, π/2)) ≈ 1.0
@test PolygonArea.distance(Point(1.0, 1.0), PolarHalfPlane(0.0, π/4)) ≈ √2
@test PolygonArea.distance(Point(2.0, 2.0), PolarHalfPlane(-√2, π/4)) ≈ √2
@test PolygonArea.distance(Point(6.0, 1.0), PolarHalfPlane(0.0, π/4, center=Point(5.0, 0.0))) ≈ √2

@test Point(0.5, 0.5) in PolarHalfPlane(-1.0, 0π)
@test Point(0.5, 0.5) in PolarHalfPlane(-1.0, π/2)
@test Point(0.5, 0.5) in PolarHalfPlane(-1.0, π)
@test Point(0.5, 0.5) in PolarHalfPlane(-1.0, 3π/2)
@test Point(1.0, 1.0) in PolarHalfPlane(-1.0, 0π)
@test Point(0.5, 2.0) in PolarHalfPlane(-1.0, 0π)
@test Point(2.0, 0.5) in PolarHalfPlane(-1.0, π/2)
@test Point(0.0, 3.0) in PolarHalfPlane(-1.0, π)

@test corner(PolarHalfPlane(0.0, 0), HalfPlane(0.0, 1.0, -1.0)) == Point(0.0, 1.0)
@test corner(PolarHalfPlane(-1.0, π/2, center=Point(0.5, 0.5)), HalfPlane(1.0, 0.0, -1.0)) == Point(1.0, 1.5)

@test PolygonArea.angle(PolarHalfPlane(0.0, π/8)) ≈ π/8
@test PolygonArea.angle(PolarHalfPlane(0.0, -π/8)) ≈ mod(-π/8, 2π)
@test PolygonArea.angle(PolarHalfPlane(4.0, π/3)) ≈ π/3

@test PolygonArea.signed_distance(Point(0.0, 0.0), PolarHalfPlane(-4.0, 2π/3)) ≈ -4.0
@test PolygonArea.signed_distance(Point(0.0, 0.0),PolarHalfPlane(4.0, π/3)) ≈ 4.0

# Rotate
@test outward_normal(rotate(PolarHalfPlane(0π), π)) == outward_normal(PolarHalfPlane(π))
@test outward_normal(rotate(PolarHalfPlane(0π, center=(1.0, 1.0)), π)) == outward_normal(PolarHalfPlane(π))
@test outward_normal(rotate(PolarHalfPlane(π/2, center=(1.0, 1.0)), π)) == outward_normal(PolarHalfPlane(3π/2))

@test outward_normal(translate(PolarHalfPlane(0π), SVector{2}(1.0, 1.0))) == outward_normal(PolarHalfPlane(0π))
@test distance(Point(0.0, 0.0), translate(PolarHalfPlane(0π), SVector{2}(1.0, 1.0))) == 1.0

# OLD TESTS

#= @test normalize(PolarHalfPlane(0.0, 0.0, 1.0, 0.0)) ≈ PolarHalfPlane(0.5, 0.0, 0.5, 0.5) =# 
#= @test normalize(PolarHalfPlane(0.0, 0.0, 0.0, 0.0)) ≈ PolarHalfPlane(-0.5, 0.0, 0.5, 0.5) =# 
#= @test normalize(PolarHalfPlane(0.0, π/2, 0.0, 0.0)) ≈ PolarHalfPlane(-0.5, π/2, 0.5, 0.5) =# 

#= @test invert_x_and_y(PolarHalfPlane(0.0, 0.0)) == PolarHalfPlane(0.0, π/2) =#
#= @test invert_x_and_y(PolarHalfPlane(1.0, 0.0)) == PolarHalfPlane(1.0, π/2) =#
#= @test invert_x_and_y(PolarHalfPlane(0.0, 0.0, 1.0, 0.0)) == PolarHalfPlane(0.0, π/2, 0.0, 1.0) =#

#= h1 = HalfPlane(0, 0, 0) =#
#= (h1 ∩ h1) ∪ (h1 ∩ h1) =#
#= invert((h1 ∪ h1) ∩ (h1 ∪ h1)) =#
#= invert((h1 ∪ h1) ∩ (h1 ∪ h1)) =#
