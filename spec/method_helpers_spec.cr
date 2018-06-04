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
end
