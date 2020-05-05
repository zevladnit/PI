#{
    ~label 'sum' 0x0
    ~label 'n' 0x1
    ~label 'i' 0x2
    ~label 'k' 0x3
    ~label 'z' 0x4
}
.ldi &(![~n]) <| $(0xAA)
.ldi &(![~i]) <| $(0x2)

;float mode ON
.ldx &(0x18) <| $(0x1)

;define float param
.orb &(0x3)
.val @float_t(4.0)
.val @float_t(2.0)
.val @float_t(3.0)
.pull &(![~sum])
.pull &(![~k])
.pull &(![~z])

;formula Nilakantha [3 + (4/(2*3*4)) - (4/(4*5*6)) + (4/(6*7*8)) - (4/(8*9*10)) ...]
.ref.t &(0xA)

.dup &(![~k]) &(0xB)
.inc &(![~k])
.mul &(0xB) &(0xB) &(![~k])
.inc &(![~k])
.mul &(0xB) &(0xB) &(![~k])

.dup &(![~z]) &(0xC)
.div &(0xC) &(![~z]) &(0xB)

.add &(![~sum]) &(![~sum]) &(0xC)

;float mode OFF for inc int
.ldx &(0x18) <| $(0x0)
.inc &(![~i])
.inc &(![~i])
;float mode ON
.ldx &(0x18) <| $(0x1)

;revert z
.neg &(![~z])

;ckeck float result
.ckft &(![~sum])

.jump.g &(0xA) ~- &(![~n]) &(![~i])

;result return to console
.mvx &(0x1) &(0x5) |> &(![~sum])
.halt

;realisation C#
;var s=3,n=5,i=2,z=4,k=2;
;
;for(n; i < n; i + 2)
;{
;    var tmpK = k;
;    k++;
;    tmpK *= k;
;    k++;
;    tmpK *= k;
;    var tmpZ = z / tmpK;
;    s = s + tmpZ;    
;    z = -z;
;}
;
;or
;
;for(n; i < n; i + 2)
;{
;    s += (z / (i * (i + 1) * (i + 2));    
;    z = -z;
;}