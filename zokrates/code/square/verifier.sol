// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

pragma solidity >=0.5.0;
pragma experimental ABIEncoderV2;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() pure internal returns (G1Point memory) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() pure internal returns (G2Point memory) {
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
    }
    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point memory p) pure internal returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2) internal returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 6, 0, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
    }
    /// @return the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint s) internal returns (G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 7, 0, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success);
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal returns (bool) {
        require(p1.length == p2.length);
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint[1] memory out;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 8, 0, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success);
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2) internal returns (bool) {
        G1Point [] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
    ) internal returns (bool) {
        G1Point [] memory p1 = new G1Point [](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
    ) internal returns (bool) {
        G1Point [] memory p1 = new G1Point [](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}
contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G2Point A;
        Pairing.G1Point  B;
        Pairing.G2Point C;
        Pairing.G2Point gamma;
        Pairing.G1Point  gammaBeta1;
        Pairing.G2Point gammaBeta2;
        Pairing.G2Point Z;
        Pairing.G1Point [] IC;
    }
    struct Proof {
        Pairing.G1Point  A;
        Pairing.G1Point A_p;
        Pairing.G2Point B;
        Pairing.G1Point B_p;
        Pairing.G1Point  C;
        Pairing.G1Point C_p;
        Pairing.G1Point K;
        Pairing.G1Point H;
    }
    function verifyingKey() pure internal returns (VerifyingKey memory vk) {
        vk.A = Pairing.G2Point([0x2144c3bbf90814b742453d7ceaf952cd2423826550ec30fae276b62301d170b5, 0x13f69fbd5073b08c69361585c9c94a2c24d4c600329b7b3d069babcf3ac0414d], [0x2a3aea094c7bd2a6899d6ba10e17aaddb3ad5cdd99c8cf97a880b12bcfe791bc, 0x29d2af21be0a8c1c9fdab7cd14c0c211f505b44ee650b7c84bc18e2e395d628]);
        vk.B = Pairing.G1Point (0x2e641214629d841c10bc52f8a5c9deea584260e38e58ff7bb776196aeaf1907e, 0xc0a45486d7f9d7abda9a0041d3d0f2487e155c2ac44cf76d52321b113f680e3);
        vk.C = Pairing.G2Point([0x2fed759a6d58a2b8ceb83dae4373a8a229678ad859307ecbfde7db0f6baef284, 0x2e73116853965a634c1913c08923267e7bd59ad23cb7006146e1b81834ab221c], [0x2d78a7c53e354f13662e821a82aa347532e9ba3bdf3673869e4966d4b9c45b89, 0xb0906312d780f5de7832128a2860570c98d5545575b52e996990b9ed5bf06e5]);
        vk.gamma = Pairing.G2Point([0xcbaecc1bebe66d6b2dc7577acff55a8212292f33427055ff7fed3e153248f74, 0x352d627cf06a2e23fdeb8962465246a945d0dab3c7df51b09229cd740125b64], [0x5d39fcb3e809aa21cdc86537c220d0b3703b1ecfb9975ae30b97c544c315a74, 0x132cfc11970fd07ed70c305659bc8c3680224b2c6b28ac154d3482dfcd52d9e]);
        vk.gammaBeta1 = Pairing.G1Point (0x1713747efd40655d1d49859677b65d452562627c2ab03958ab6bb295a4adc705, 0xbc8375cb262be4ad065728d7fcf96a7cac286530cb38ef7b9db62f4117e91fa);
        vk.gammaBeta2 = Pairing.G2Point([0x26cacaba06ffc16878e0e405c074d58233706ed43dcda847ef6df5840af0d3da, 0x1348e13ac6a196de2bb22e6844b31314a607e1eda9ecc4dc286b6925386cf27e], [0x2d5638a749c0e9180a2718e6e1653cc2b31bdd4de5317a7f7473f65a6c8a2d05, 0xb8dfb303993bc6d51e19c1ebf8016cb418ca9df4e348ec93ff9d13a829ea1e1]);
        vk.Z = Pairing.G2Point([0x9b83dc21046b976706749b72fe0bd6283295adebe891fb48c4c0a5d6443a014, 0x245f3fdb16f4000a5f391af11e30a8b89d746ebc4d5c5718510ffe53e6dff4d9], [0x166018a37ee5b5e59bd97eed42def0bdc0ad0b8cbd03762c5b8957dbd6d0f9c, 0x10248651395c25ad857410244f78e67fcf60a046487fdf42ccc6e198460b8a13]);
        vk.IC = new Pairing.G1Point [](3);
        vk.IC[0] = Pairing.G1Point (0x265be2e38e48b84e075ebdae90a51f45bd098b8457b0ef1c7da6dcc85a999766, 0x2e9e77efc5fe181f371b67b8e85ae64686f08aac2ba507da911752cdbad6e7d1);
        vk.IC[1] = Pairing.G1Point (0x1e335d15ec79fe9938d59cbfb489ccc34d7ea6379d79b018389f12c1c2796e20, 0x2d2162d0073dfdcb491cc0f6d66235b2f426900fa144e0b71a90b2362b478e80);
        vk.IC[2] = Pairing.G1Point (0x4752d79e3e6ec483346f8d3be8aa00519e302050260976f21c77469499c5e49, 0x12a53638b71ac0465b54ac35c9702a441ad361c1837a3b98cf3021dc2b4cc971);
    }
    function verify(uint[] memory input, Proof memory proof) internal returns (uint) {
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++)
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (!Pairing.pairingProd2(proof.A, vk.A, Pairing.negate(proof.A_p), Pairing.P2())) return 1;
        if (!Pairing.pairingProd2(vk.B, proof.B, Pairing.negate(proof.B_p), Pairing.P2())) return 2;
        if (!Pairing.pairingProd2(proof.C, vk.C, Pairing.negate(proof.C_p), Pairing.P2())) return 3;
        if (!Pairing.pairingProd3(
            proof.K, vk.gamma,
            Pairing.negate(Pairing.addition(vk_x, Pairing.addition(proof.A, proof.C))), vk.gammaBeta2,
            Pairing.negate(vk.gammaBeta1), proof.B
        )) return 4;
        if (!Pairing.pairingProd3(
                Pairing.addition(vk_x, proof.A), proof.B,
                Pairing.negate(proof.H), vk.Z,
                Pairing.negate(proof.C), Pairing.P2()
        )) return 5;
        return 0;
    }
    event Verified(string s);
    function verifyTx(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[2] memory input
        ) public returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            emit Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
