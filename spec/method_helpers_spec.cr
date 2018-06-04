require "./spec_helper"

class Car
  getter odometer : Int32 = 0

  def drive(distance : Int32)
    @odometer = odometer + distance
  end
end

describe MethodHelpers do
  test "simple example works on its own" do
    sedan = Car.new
    sedan.drive(4)
    sedan.drive(8)
    sedan.drive(15)
    sedan.drive(16)
    assert sedan.odometer == 43
  end

  test "that I can get method names" do
    assert Car.methods.names.sort == ["drive", "odometer"].sort
  end

  test "that I can get method names with arity" do
    assert Car.methods.names_with_arity.sort == ["drive/1", "odometer/0"].sort
  end

  test "that I can get the full method signature" do
    methods = Car.methods
    assert methods.size == 2

    odometer = methods[0]
    assert odometer.name == "odometer"
    assert odometer.return_type == "Int32"
    assert odometer.args == [] of String

    drive = methods[1]
    assert drive.name == "drive"
    assert drive.return_type == nil
    assert drive.args.try &.size == 1

    drive.args.try do |drive_args|
      distance = drive_args[0]
      assert distance.argname == "distance"
      assert distance.argtype == nil
    end
  end
end
