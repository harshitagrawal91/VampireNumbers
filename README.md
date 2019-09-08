# Vampire Numbers #
An interesting kind of number in mathematics is vampire number (Links to an external site.). A vampire number is a composite (Links to an external site.) natural number (Links to an external site.) with an even number of digits, that can be factored into two natural numbers each with half as many digits as the original number and not both with trailing zeroes, where the two factors contain precisely all the digits of the original number, in any order, counting multiplicity.  A classic example is: 1260= 21 x 60.
A vampire number can have multiple distinct pairs of fangs. A vampire numbers with 2 pairs of fangs is: 125460 = 204 × 615 = 246 × 510.

Input: The input provided (as command line to your program, e.g. my_app) will be two numbers: N1 and N2. The overall goal of your program is to find all vampire numbers starting at N1 and up to N2.

Output: Print, on independent lines, first the number then its fangs. If there are multiple fangs list all of them next to each other

## 1. How to Run: ##
    1. Go inside project Directory  
    2. mix run proj1.exs 100000 200000

## 2. Number of Worker & Size of Work Unit:
The Application is creating different numbers of worker depending on Range of numbers for the optimized performance. The program was tested for a lot of combinations and 1/10th chunk of work for range 1 to1000000 and 1/100th for range 1000000 to infinity to each process seemed to give us the most optimized output.

## 3. Result  
Command:- mix run proj1.exs 100000 200000

Output:-

102510 201 510

104260 260 401

105210 210 501

105264 204 516

105750 150 705

108135 135 801

110758 158 701

115672 152 761

116725 161 725

117067 167 701

118440 141 840

120600 201 600

123354 231 534

124483 281 443

125248 152 824

125433 231 543

125460 204 615 246 510

125500 251 500

126027 201 627

126846 261 486

129640 140 926

129775 179 725

131242 311 422

132430 323 410

133245 315 423

134725 317 425

135828 231 588

135837 351 387

136525 215 635

136948 146 938

140350 350 401

145314 351 414

146137 317 461

146952 156 942

150300 300 501

152608 251 608

152685 261 585

153436 356 431

156240 240 651

156289 269 581

156915 165 951

162976 176 926

163944 396 414

172822 221 782

173250 231 750

174370 371 470

175329 231 759

180225 225 801

180297 201 897

182250 225 810

182650 281 650

186624 216 864

190260 210 906

192150 210 915

193257 327 591

193945 395 491

197725 275 719


 
## 4. CPU time to Real time  ##
mix run proj1.exs 100000 200000

    real	0m8.480s
    user	0m9.865s
    sys 	0m0.156s
mix run proj1.exs 100000 900000

    real	0m3.526s
    user	0m25.634s
    sys 	0m0.221s

## 5. Largest Problem Solved ##
 
mix run proj1.exs 100000000 200000000

## 6. Snapshot for Observer ##
## 7. Team Members ##
Harshit Agrawal--9041-1685

Shantanu Ghosh--
