library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    use work.float_type_definitions_pkg.all;
    use work.float_arithmetic_operations_pkg.all;

package float_multiplier_pkg is
------------------------------------------------------------------------
    type float_multiplier_record is record
        float_multiplier_is_done : boolean;
        float_multiplier_is_requested : boolean;
    end record;

    constant init_float_multiplier : float_multiplier_record := (false, false);
------------------------------------------------------------------------
    procedure create_float_multiplier (
        signal float_multiplier_object : inout float_multiplier_record);
------------------------------------------------------------------------
    procedure request_float_multiplier (
        signal float_multiplier_object : out float_multiplier_record);
------------------------------------------------------------------------
    function float_multiplier_is_ready (float_multiplier_object : float_multiplier_record)
        return boolean;
------------------------------------------------------------------------
    function mult ( left,right : natural)
        return unsigned;
------------------------------------------------------------------------
    function "*" ( left, right : float_record)
        return float_record;
------------------------------------------------------------------------
end package float_multiplier_pkg;

package body float_multiplier_pkg is
------------------------------------------------------------------------
    function mult
    (
        left,right : natural
    )
    return unsigned 
    is
        variable result : unsigned(mantissa_length*2+1 downto 0) := (others => '0');

    begin
        result := to_unsigned(left, mantissa_length+1) * to_unsigned(right,mantissa_length+1);
        
        return result(mantissa_high*2+1 downto mantissa_high+1);
    end mult;

------------------------------------------------------------------------
    function "*"
    (
        left, right : float_record
    ) return float_record
    is
        variable result : float_record := zero;
    begin

        result.sign     := left.sign xor right.sign;
        result.exponent := left.exponent + right.exponent;
        result.mantissa := mult(to_integer(left.mantissa) , to_integer(right.mantissa));
        return result;
        
    end function;
------------------------------------------------------------------------

    procedure create_float_multiplier 
    (
        signal float_multiplier_object : inout float_multiplier_record
    ) 
    is
        alias float_multiplier_is_requested is float_multiplier_object.float_multiplier_is_requested;
        alias float_multiplier_is_done is float_multiplier_object.float_multiplier_is_done;
    begin
        float_multiplier_is_requested <= false;
        if float_multiplier_is_requested then
            float_multiplier_is_done <= true;
        else
            float_multiplier_is_done <= false;
        end if;
    end procedure;

------------------------------------------------------------------------
    procedure request_float_multiplier
    (
        signal float_multiplier_object : out float_multiplier_record
    ) is
    begin
        float_multiplier_object.float_multiplier_is_requested <= true;
        
    end request_float_multiplier;

------------------------------------------------------------------------
    function float_multiplier_is_ready
    (
        float_multiplier_object : float_multiplier_record
    )
    return boolean
    is
    begin
        return float_multiplier_object.float_multiplier_is_done;
    end float_multiplier_is_ready;

------------------------------------------------------------------------
end package body float_multiplier_pkg;