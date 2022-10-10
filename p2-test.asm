
_p2-test:     file format elf32-i386


Disassembly of section .text:

00000000 <testinvalidarray>:
  free(table);
  return success;
}

static int
testinvalidarray(void){
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	56                   	push   %esi
       4:	53                   	push   %ebx
  struct uproc * table;
  int ret;

  table = malloc(sizeof(struct uproc));
       5:	83 ec 0c             	sub    $0xc,%esp
       8:	6a 60                	push   $0x60
       a:	e8 cb 10 00 00       	call   10da <malloc>
  if (!table) {
       f:	83 c4 10             	add    $0x10,%esp
      12:	85 c0                	test   %eax,%eax
      14:	74 2d                	je     43 <testinvalidarray+0x43>
      16:	89 c3                	mov    %eax,%ebx
    printf(2, "Error: malloc() call failed. %s at line %d\n", __FUNCTION__, __LINE__);
    exit();
  }
  ret = getprocs(1024, table);
      18:	83 ec 08             	sub    $0x8,%esp
      1b:	50                   	push   %eax
      1c:	68 00 04 00 00       	push   $0x400
      21:	e8 ca 0d 00 00       	call   df0 <getprocs>
      26:	89 c6                	mov    %eax,%esi
  free(table);
      28:	89 1c 24             	mov    %ebx,(%esp)
      2b:	e8 e6 0f 00 00       	call   1016 <free>
  if(ret >= 0){
      30:	83 c4 10             	add    $0x10,%esp
      33:	85 f6                	test   %esi,%esi
      35:	79 27                	jns    5e <testinvalidarray+0x5e>
    printf(2, "FAILED: called getprocs with max way larger than table and returned %d, not error\n", ret);
    return -1;
  }
  return 0;
      37:	b8 00 00 00 00       	mov    $0x0,%eax
}
      3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
      3f:	5b                   	pop    %ebx
      40:	5e                   	pop    %esi
      41:	5d                   	pop    %ebp
      42:	c3                   	ret    
    printf(2, "Error: malloc() call failed. %s at line %d\n", __FUNCTION__, __LINE__);
      43:	68 06 01 00 00       	push   $0x106
      48:	68 c8 17 00 00       	push   $0x17c8
      4d:	68 68 11 00 00       	push   $0x1168
      52:	6a 02                	push   $0x2
      54:	e8 50 0e 00 00       	call   ea9 <printf>
    exit();
      59:	e8 ba 0c 00 00       	call   d18 <exit>
    printf(2, "FAILED: called getprocs with max way larger than table and returned %d, not error\n", ret);
      5e:	83 ec 04             	sub    $0x4,%esp
      61:	56                   	push   %esi
      62:	68 94 11 00 00       	push   $0x1194
      67:	6a 02                	push   $0x2
      69:	e8 3b 0e 00 00       	call   ea9 <printf>
    return -1;
      6e:	83 c4 10             	add    $0x10,%esp
      71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      76:	eb c4                	jmp    3c <testinvalidarray+0x3c>

00000078 <testprocarray>:
testprocarray(int max, int expected_ret){
      78:	55                   	push   %ebp
      79:	89 e5                	mov    %esp,%ebp
      7b:	57                   	push   %edi
      7c:	56                   	push   %esi
      7d:	53                   	push   %ebx
      7e:	83 ec 18             	sub    $0x18,%esp
      81:	89 c3                	mov    %eax,%ebx
      83:	89 d7                	mov    %edx,%edi
  table = malloc(sizeof(struct uproc) * max);  // bad code, assumes success
      85:	8d 04 40             	lea    (%eax,%eax,2),%eax
      88:	c1 e0 05             	shl    $0x5,%eax
      8b:	50                   	push   %eax
      8c:	e8 49 10 00 00       	call   10da <malloc>
  if (!table) {
      91:	83 c4 10             	add    $0x10,%esp
      94:	85 c0                	test   %eax,%eax
      96:	74 3c                	je     d4 <testprocarray+0x5c>
      98:	89 c6                	mov    %eax,%esi
  ret = getprocs(max, table);
      9a:	83 ec 08             	sub    $0x8,%esp
      9d:	50                   	push   %eax
      9e:	53                   	push   %ebx
      9f:	e8 4c 0d 00 00       	call   df0 <getprocs>
  if (ret != expected_ret){
      a4:	83 c4 10             	add    $0x10,%esp
      a7:	39 f8                	cmp    %edi,%eax
      a9:	75 44                	jne    ef <testprocarray+0x77>
    printf(2, "getprocs() was asked for %d processes and returned %d. SUCCESS\n", max, expected_ret);
      ab:	57                   	push   %edi
      ac:	53                   	push   %ebx
      ad:	68 18 12 00 00       	push   $0x1218
      b2:	6a 02                	push   $0x2
      b4:	e8 f0 0d 00 00       	call   ea9 <printf>
      b9:	83 c4 10             	add    $0x10,%esp
  int ret, success = 0;
      bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  free(table);
      c1:	83 ec 0c             	sub    $0xc,%esp
      c4:	56                   	push   %esi
      c5:	e8 4c 0f 00 00       	call   1016 <free>
}
      ca:	89 d8                	mov    %ebx,%eax
      cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      cf:	5b                   	pop    %ebx
      d0:	5e                   	pop    %esi
      d1:	5f                   	pop    %edi
      d2:	5d                   	pop    %ebp
      d3:	c3                   	ret    
    printf(2, "Error: malloc() call failed. %s at line %d\n", __FUNCTION__, __LINE__);
      d4:	68 f0 00 00 00       	push   $0xf0
      d9:	68 b8 17 00 00       	push   $0x17b8
      de:	68 68 11 00 00       	push   $0x1168
      e3:	6a 02                	push   $0x2
      e5:	e8 bf 0d 00 00       	call   ea9 <printf>
    exit();
      ea:	e8 29 0c 00 00       	call   d18 <exit>
    printf(2, "FAILED: getprocs(%d) returned %d, expected %d\n", max, ret, expected_ret);
      ef:	83 ec 0c             	sub    $0xc,%esp
      f2:	57                   	push   %edi
      f3:	50                   	push   %eax
      f4:	53                   	push   %ebx
      f5:	68 e8 11 00 00       	push   $0x11e8
      fa:	6a 02                	push   $0x2
      fc:	e8 a8 0d 00 00       	call   ea9 <printf>
    success = -1;
     101:	83 c4 20             	add    $0x20,%esp
     104:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
     109:	eb b6                	jmp    c1 <testprocarray+0x49>

0000010b <testgetprocs>:

static void
testgetprocs(){
     10b:	55                   	push   %ebp
     10c:	89 e5                	mov    %esp,%ebp
     10e:	53                   	push   %ebx
     10f:	83 ec 0c             	sub    $0xc,%esp
  int ret, success;

  printf(1, "\n----------\nRunning GetProcs Test\n----------\n");
     112:	68 58 12 00 00       	push   $0x1258
     117:	6a 01                	push   $0x1
     119:	e8 8b 0d 00 00       	call   ea9 <printf>
  printf(1, "Filling the proc[] array with dummy processes\n");
     11e:	83 c4 08             	add    $0x8,%esp
     121:	68 88 12 00 00       	push   $0x1288
     126:	6a 01                	push   $0x1
     128:	e8 7c 0d 00 00       	call   ea9 <printf>
  // Fork until no space left in ptable
  ret = fork();
     12d:	e8 de 0b 00 00       	call   d10 <fork>
  if (ret == 0){
     132:	83 c4 10             	add    $0x10,%esp
     135:	85 c0                	test   %eax,%eax
     137:	75 7b                	jne    1b4 <testgetprocs+0xa9>
    while((ret = fork()) == 0);
     139:	e8 d2 0b 00 00       	call   d10 <fork>
     13e:	85 c0                	test   %eax,%eax
     140:	74 f7                	je     139 <testgetprocs+0x2e>
    if(ret > 0){
     142:	7e 0a                	jle    14e <testgetprocs+0x43>
      wait();
     144:	e8 d7 0b 00 00       	call   d20 <wait>
      exit();
     149:	e8 ca 0b 00 00       	call   d18 <exit>
    }
    // Only return left is -1, which is no space left in ptable
    success  = testinvalidarray();
     14e:	e8 ad fe ff ff       	call   0 <testinvalidarray>
     153:	89 c3                	mov    %eax,%ebx
    success |= testprocarray( 1,  1);
     155:	ba 01 00 00 00       	mov    $0x1,%edx
     15a:	b8 01 00 00 00       	mov    $0x1,%eax
     15f:	e8 14 ff ff ff       	call   78 <testprocarray>
     164:	09 c3                	or     %eax,%ebx
    success |= testprocarray(16, 16);
     166:	ba 10 00 00 00       	mov    $0x10,%edx
     16b:	b8 10 00 00 00       	mov    $0x10,%eax
     170:	e8 03 ff ff ff       	call   78 <testprocarray>
     175:	09 c3                	or     %eax,%ebx
    success |= testprocarray(64, 64);
     177:	ba 40 00 00 00       	mov    $0x40,%edx
     17c:	b8 40 00 00 00       	mov    $0x40,%eax
     181:	e8 f2 fe ff ff       	call   78 <testprocarray>
     186:	09 c3                	or     %eax,%ebx
    success |= testprocarray(72, 64);
     188:	ba 40 00 00 00       	mov    $0x40,%edx
     18d:	b8 48 00 00 00       	mov    $0x48,%eax
     192:	e8 e1 fe ff ff       	call   78 <testprocarray>
    if (success == 0)
     197:	09 c3                	or     %eax,%ebx
     199:	74 05                	je     1a0 <testgetprocs+0x95>
      printf(1, "** All Tests Passed **\n");
    exit();
     19b:	e8 78 0b 00 00       	call   d18 <exit>
      printf(1, "** All Tests Passed **\n");
     1a0:	83 ec 08             	sub    $0x8,%esp
     1a3:	68 cc 16 00 00       	push   $0x16cc
     1a8:	6a 01                	push   $0x1
     1aa:	e8 fa 0c 00 00       	call   ea9 <printf>
     1af:	83 c4 10             	add    $0x10,%esp
     1b2:	eb e7                	jmp    19b <testgetprocs+0x90>
  }
  wait();
     1b4:	e8 67 0b 00 00       	call   d20 <wait>
}
     1b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     1bc:	c9                   	leave  
     1bd:	c3                   	ret    

000001be <getcputime>:
getcputime(char * name, struct uproc * table){
     1be:	55                   	push   %ebp
     1bf:	89 e5                	mov    %esp,%ebp
     1c1:	57                   	push   %edi
     1c2:	56                   	push   %esi
     1c3:	53                   	push   %ebx
     1c4:	83 ec 24             	sub    $0x24,%esp
     1c7:	89 c7                	mov    %eax,%edi
     1c9:	89 55 e0             	mov    %edx,-0x20(%ebp)
  size = getprocs(64, table);
     1cc:	52                   	push   %edx
     1cd:	6a 40                	push   $0x40
     1cf:	e8 1c 0c 00 00       	call   df0 <getprocs>
     1d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(int i = 0; i < size; ++i){
     1d7:	83 c4 10             	add    $0x10,%esp
     1da:	be 00 00 00 00       	mov    $0x0,%esi
     1df:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
     1e2:	7d 22                	jge    206 <getcputime+0x48>
    if(strcmp(table[i].name, name) == 0){
     1e4:	8d 1c 76             	lea    (%esi,%esi,2),%ebx
     1e7:	c1 e3 05             	shl    $0x5,%ebx
     1ea:	03 5d e0             	add    -0x20(%ebp),%ebx
     1ed:	8d 43 40             	lea    0x40(%ebx),%eax
     1f0:	83 ec 08             	sub    $0x8,%esp
     1f3:	57                   	push   %edi
     1f4:	50                   	push   %eax
     1f5:	e8 b2 08 00 00       	call   aac <strcmp>
     1fa:	83 c4 10             	add    $0x10,%esp
     1fd:	85 c0                	test   %eax,%eax
     1ff:	74 0a                	je     20b <getcputime+0x4d>
  for(int i = 0; i < size; ++i){
     201:	83 c6 01             	add    $0x1,%esi
     204:	eb d9                	jmp    1df <getcputime+0x21>
  struct uproc *p = 0;
     206:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(p == 0){
     20b:	85 db                	test   %ebx,%ebx
     20d:	74 0b                	je     21a <getcputime+0x5c>
    return p->CPU_total_ticks;
     20f:	8b 43 18             	mov    0x18(%ebx),%eax
}
     212:	8d 65 f4             	lea    -0xc(%ebp),%esp
     215:	5b                   	pop    %ebx
     216:	5e                   	pop    %esi
     217:	5f                   	pop    %edi
     218:	5d                   	pop    %ebp
     219:	c3                   	ret    
    printf(2, "FAILED: Test program \"%s\" not found in table returned by getprocs\n", name);
     21a:	83 ec 04             	sub    $0x4,%esp
     21d:	57                   	push   %edi
     21e:	68 b8 12 00 00       	push   $0x12b8
     223:	6a 02                	push   $0x2
     225:	e8 7f 0c 00 00       	call   ea9 <printf>
    return -1;
     22a:	83 c4 10             	add    $0x10,%esp
     22d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     232:	eb de                	jmp    212 <getcputime+0x54>

00000234 <testcputime>:
testcputime(char * name){
     234:	55                   	push   %ebp
     235:	89 e5                	mov    %esp,%ebp
     237:	57                   	push   %edi
     238:	56                   	push   %esi
     239:	53                   	push   %ebx
     23a:	83 ec 24             	sub    $0x24,%esp
     23d:	89 c7                	mov    %eax,%edi
  printf(1, "\n----------\nRunning CPU Time Test\n----------\n");
     23f:	68 fc 12 00 00       	push   $0x12fc
     244:	6a 01                	push   $0x1
     246:	e8 5e 0c 00 00       	call   ea9 <printf>
  table = malloc(sizeof(struct uproc) * 64);
     24b:	c7 04 24 00 18 00 00 	movl   $0x1800,(%esp)
     252:	e8 83 0e 00 00       	call   10da <malloc>
     257:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if (!table) {
     25a:	83 c4 10             	add    $0x10,%esp
     25d:	85 c0                	test   %eax,%eax
     25f:	74 32                	je     293 <testcputime+0x5f>
  printf(1, "This will take a couple seconds\n");
     261:	83 ec 08             	sub    $0x8,%esp
     264:	68 2c 13 00 00       	push   $0x132c
     269:	6a 01                	push   $0x1
     26b:	e8 39 0c 00 00       	call   ea9 <printf>
  time1 = getcputime(name, table);
     270:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     273:	89 f8                	mov    %edi,%eax
     275:	e8 44 ff ff ff       	call   1be <getcputime>
     27a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(i = 0, num = 0; i < 1000000; ++i){
     27d:	83 c4 10             	add    $0x10,%esp
     280:	bb 00 00 00 00       	mov    $0x0,%ebx
     285:	be 00 00 00 00       	mov    $0x0,%esi
  int success = 0;
     28a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  for(i = 0, num = 0; i < 1000000; ++i){
     291:	eb 37                	jmp    2ca <testcputime+0x96>
    printf(2, "Error: malloc() call failed. %s at line %d\n", __FUNCTION__, __LINE__);
     293:	68 c1 00 00 00       	push   $0xc1
     298:	68 dc 17 00 00       	push   $0x17dc
     29d:	68 68 11 00 00       	push   $0x1168
     2a2:	6a 02                	push   $0x2
     2a4:	e8 00 0c 00 00       	call   ea9 <printf>
    exit();
     2a9:	e8 6a 0a 00 00       	call   d18 <exit>
        printf(2, "FAILED: CPU_total_ticks changed by 100+ milliseconds while process was asleep\n");
     2ae:	83 ec 08             	sub    $0x8,%esp
     2b1:	68 50 13 00 00       	push   $0x1350
     2b6:	6a 02                	push   $0x2
     2b8:	e8 ec 0b 00 00       	call   ea9 <printf>
     2bd:	83 c4 10             	add    $0x10,%esp
        success = -1;
     2c0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  for(i = 0, num = 0; i < 1000000; ++i){
     2c7:	83 c6 01             	add    $0x1,%esi
     2ca:	81 fe 3f 42 0f 00    	cmp    $0xf423f,%esi
     2d0:	7f 51                	jg     323 <testcputime+0xef>
    ++num;
     2d2:	83 c3 01             	add    $0x1,%ebx
    if(num % 100000 == 0){
     2d5:	ba 89 b5 f8 14       	mov    $0x14f8b589,%edx
     2da:	89 d8                	mov    %ebx,%eax
     2dc:	f7 ea                	imul   %edx
     2de:	c1 fa 0d             	sar    $0xd,%edx
     2e1:	89 d8                	mov    %ebx,%eax
     2e3:	c1 f8 1f             	sar    $0x1f,%eax
     2e6:	29 c2                	sub    %eax,%edx
     2e8:	69 d2 a0 86 01 00    	imul   $0x186a0,%edx,%edx
     2ee:	39 d3                	cmp    %edx,%ebx
     2f0:	75 d5                	jne    2c7 <testcputime+0x93>
      pre_sleep = getcputime(name, table);
     2f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     2f5:	89 f8                	mov    %edi,%eax
     2f7:	e8 c2 fe ff ff       	call   1be <getcputime>
     2fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
      sleep(200);
     2ff:	83 ec 0c             	sub    $0xc,%esp
     302:	68 c8 00 00 00       	push   $0xc8
     307:	e8 9c 0a 00 00       	call   da8 <sleep>
      post_sleep = getcputime(name, table);
     30c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     30f:	89 f8                	mov    %edi,%eax
     311:	e8 a8 fe ff ff       	call   1be <getcputime>
      if((post_sleep - pre_sleep) >= 100){
     316:	2b 45 e0             	sub    -0x20(%ebp),%eax
     319:	83 c4 10             	add    $0x10,%esp
     31c:	83 f8 63             	cmp    $0x63,%eax
     31f:	76 a6                	jbe    2c7 <testcputime+0x93>
     321:	eb 8b                	jmp    2ae <testcputime+0x7a>
  time2 = getcputime(name, table);
     323:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     326:	89 f8                	mov    %edi,%eax
     328:	e8 91 fe ff ff       	call   1be <getcputime>
  if((time2 - time1) > 400){
     32d:	2b 45 d8             	sub    -0x28(%ebp),%eax
     330:	89 c3                	mov    %eax,%ebx
     332:	3d 90 01 00 00       	cmp    $0x190,%eax
     337:	77 2c                	ja     365 <testcputime+0x131>
  printf(1, "T2 - T1 = %d milliseconds\n", (time2 - time1));
     339:	83 ec 04             	sub    $0x4,%esp
     33c:	53                   	push   %ebx
     33d:	68 e4 16 00 00       	push   $0x16e4
     342:	6a 01                	push   $0x1
     344:	e8 60 0b 00 00       	call   ea9 <printf>
  free(table);
     349:	83 c4 04             	add    $0x4,%esp
     34c:	ff 75 e4             	pushl  -0x1c(%ebp)
     34f:	e8 c2 0c 00 00       	call   1016 <free>
  if(success == 0)
     354:	83 c4 10             	add    $0x10,%esp
     357:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
     35b:	74 24                	je     381 <testcputime+0x14d>
}
     35d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     360:	5b                   	pop    %ebx
     361:	5e                   	pop    %esi
     362:	5f                   	pop    %edi
     363:	5d                   	pop    %ebp
     364:	c3                   	ret    
    printf(2, "ABNORMALLY HIGH: T2 - T1 = %d milliseconds.  Run test again\n", (time2 - time1));
     365:	83 ec 04             	sub    $0x4,%esp
     368:	50                   	push   %eax
     369:	68 a0 13 00 00       	push   $0x13a0
     36e:	6a 02                	push   $0x2
     370:	e8 34 0b 00 00       	call   ea9 <printf>
     375:	83 c4 10             	add    $0x10,%esp
    success = -1;
     378:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
     37f:	eb b8                	jmp    339 <testcputime+0x105>
    printf(1, "** All Tests Passed! **\n");
     381:	83 ec 08             	sub    $0x8,%esp
     384:	68 ff 16 00 00       	push   $0x16ff
     389:	6a 01                	push   $0x1
     38b:	e8 19 0b 00 00       	call   ea9 <printf>
     390:	83 c4 10             	add    $0x10,%esp
}
     393:	eb c8                	jmp    35d <testcputime+0x129>

00000395 <testuid>:
testuid(uint new_val, uint expected_get_val, int expected_set_ret){
     395:	55                   	push   %ebp
     396:	89 e5                	mov    %esp,%ebp
     398:	57                   	push   %edi
     399:	56                   	push   %esi
     39a:	53                   	push   %ebx
     39b:	83 ec 1c             	sub    $0x1c,%esp
     39e:	89 c3                	mov    %eax,%ebx
     3a0:	89 d7                	mov    %edx,%edi
     3a2:	89 ce                	mov    %ecx,%esi
  pre_uid = getuid();
     3a4:	e8 1f 0a 00 00       	call   dc8 <getuid>
     3a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  ret = setuid(new_val);
     3ac:	83 ec 0c             	sub    $0xc,%esp
     3af:	53                   	push   %ebx
     3b0:	e8 2b 0a 00 00       	call   de0 <setuid>
  if((ret < 0 && expected_set_ret >= 0) || (ret >= 0 && expected_set_ret < 0)){
     3b5:	89 c1                	mov    %eax,%ecx
     3b7:	c1 e9 1f             	shr    $0x1f,%ecx
     3ba:	89 f2                	mov    %esi,%edx
     3bc:	c1 ea 1f             	shr    $0x1f,%edx
     3bf:	83 c4 10             	add    $0x10,%esp
     3c2:	38 d1                	cmp    %dl,%cl
     3c4:	75 18                	jne    3de <testuid+0x49>
  int success = 0;
     3c6:	be 00 00 00 00       	mov    $0x0,%esi
  post_uid = getuid();
     3cb:	e8 f8 09 00 00       	call   dc8 <getuid>
  if(post_uid != expected_get_val){
     3d0:	39 f8                	cmp    %edi,%eax
     3d2:	75 26                	jne    3fa <testuid+0x65>
}
     3d4:	89 f0                	mov    %esi,%eax
     3d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
     3d9:	5b                   	pop    %ebx
     3da:	5e                   	pop    %esi
     3db:	5f                   	pop    %edi
     3dc:	5d                   	pop    %ebp
     3dd:	c3                   	ret    
    printf(2, "FAILED: setuid(%d) returned %d, expected %d\n", new_val, ret, expected_set_ret);
     3de:	83 ec 0c             	sub    $0xc,%esp
     3e1:	56                   	push   %esi
     3e2:	50                   	push   %eax
     3e3:	53                   	push   %ebx
     3e4:	68 e0 13 00 00       	push   $0x13e0
     3e9:	6a 02                	push   $0x2
     3eb:	e8 b9 0a 00 00       	call   ea9 <printf>
     3f0:	83 c4 20             	add    $0x20,%esp
    success = -1;
     3f3:	be ff ff ff ff       	mov    $0xffffffff,%esi
     3f8:	eb d1                	jmp    3cb <testuid+0x36>
    printf(2, "FAILED: UID was %d. After setuid(%d), getuid() returned %d, expected %d\n",
     3fa:	83 ec 08             	sub    $0x8,%esp
     3fd:	57                   	push   %edi
     3fe:	50                   	push   %eax
     3ff:	53                   	push   %ebx
     400:	ff 75 e4             	pushl  -0x1c(%ebp)
     403:	68 10 14 00 00       	push   $0x1410
     408:	6a 02                	push   $0x2
     40a:	e8 9a 0a 00 00       	call   ea9 <printf>
     40f:	83 c4 20             	add    $0x20,%esp
    success = -1;
     412:	be ff ff ff ff       	mov    $0xffffffff,%esi
  return success;
     417:	eb bb                	jmp    3d4 <testuid+0x3f>

00000419 <testgid>:
testgid(uint new_val, uint expected_get_val, int expected_set_ret){
     419:	55                   	push   %ebp
     41a:	89 e5                	mov    %esp,%ebp
     41c:	57                   	push   %edi
     41d:	56                   	push   %esi
     41e:	53                   	push   %ebx
     41f:	83 ec 1c             	sub    $0x1c,%esp
     422:	89 c3                	mov    %eax,%ebx
     424:	89 d7                	mov    %edx,%edi
     426:	89 ce                	mov    %ecx,%esi
  pre_gid = getgid();
     428:	e8 a3 09 00 00       	call   dd0 <getgid>
     42d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  ret = setgid(new_val);
     430:	83 ec 0c             	sub    $0xc,%esp
     433:	53                   	push   %ebx
     434:	e8 af 09 00 00       	call   de8 <setgid>
  if((ret < 0 && expected_set_ret >= 0) || (ret >= 0 && expected_set_ret < 0)){
     439:	89 c1                	mov    %eax,%ecx
     43b:	c1 e9 1f             	shr    $0x1f,%ecx
     43e:	89 f2                	mov    %esi,%edx
     440:	c1 ea 1f             	shr    $0x1f,%edx
     443:	83 c4 10             	add    $0x10,%esp
     446:	38 d1                	cmp    %dl,%cl
     448:	75 18                	jne    462 <testgid+0x49>
  int success = 0;
     44a:	be 00 00 00 00       	mov    $0x0,%esi
  post_gid = getgid();
     44f:	e8 7c 09 00 00       	call   dd0 <getgid>
  if(post_gid != expected_get_val){
     454:	39 f8                	cmp    %edi,%eax
     456:	75 26                	jne    47e <testgid+0x65>
}
     458:	89 f0                	mov    %esi,%eax
     45a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     45d:	5b                   	pop    %ebx
     45e:	5e                   	pop    %esi
     45f:	5f                   	pop    %edi
     460:	5d                   	pop    %ebp
     461:	c3                   	ret    
    printf(2, "FAILED: setgid(%d) returned %d, expected %d\n", new_val, ret, expected_set_ret);
     462:	83 ec 0c             	sub    $0xc,%esp
     465:	56                   	push   %esi
     466:	50                   	push   %eax
     467:	53                   	push   %ebx
     468:	68 5c 14 00 00       	push   $0x145c
     46d:	6a 02                	push   $0x2
     46f:	e8 35 0a 00 00       	call   ea9 <printf>
     474:	83 c4 20             	add    $0x20,%esp
    success = -1;
     477:	be ff ff ff ff       	mov    $0xffffffff,%esi
     47c:	eb d1                	jmp    44f <testgid+0x36>
    printf(2, "FAILED: UID was %d. After setgid(%d), getgid() returned %d, expected %d\n",
     47e:	83 ec 08             	sub    $0x8,%esp
     481:	57                   	push   %edi
     482:	50                   	push   %eax
     483:	53                   	push   %ebx
     484:	ff 75 e4             	pushl  -0x1c(%ebp)
     487:	68 8c 14 00 00       	push   $0x148c
     48c:	6a 02                	push   $0x2
     48e:	e8 16 0a 00 00       	call   ea9 <printf>
     493:	83 c4 20             	add    $0x20,%esp
    success = -1;
     496:	be ff ff ff ff       	mov    $0xffffffff,%esi
  return success;
     49b:	eb bb                	jmp    458 <testgid+0x3f>

0000049d <testuidgid>:
{
     49d:	55                   	push   %ebp
     49e:	89 e5                	mov    %esp,%ebp
     4a0:	53                   	push   %ebx
     4a1:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "\n----------\nRunning UID / GID Tests\n----------\n");
     4a4:	68 d8 14 00 00       	push   $0x14d8
     4a9:	6a 01                	push   $0x1
     4ab:	e8 f9 09 00 00       	call   ea9 <printf>
  uid = getuid();
     4b0:	e8 13 09 00 00       	call   dc8 <getuid>
  if(uid < 0 || uid > 32767){
     4b5:	83 c4 10             	add    $0x10,%esp
     4b8:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
     4bd:	0f 87 3b 01 00 00    	ja     5fe <testuidgid+0x161>
  int success = 0;
     4c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (testuid(0, 0, 0))
     4c8:	b9 00 00 00 00       	mov    $0x0,%ecx
     4cd:	ba 00 00 00 00       	mov    $0x0,%edx
     4d2:	b8 00 00 00 00       	mov    $0x0,%eax
     4d7:	e8 b9 fe ff ff       	call   395 <testuid>
     4dc:	85 c0                	test   %eax,%eax
     4de:	74 05                	je     4e5 <testuidgid+0x48>
    success = -1;
     4e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if (testuid(5, 5, 0))
     4e5:	b9 00 00 00 00       	mov    $0x0,%ecx
     4ea:	ba 05 00 00 00       	mov    $0x5,%edx
     4ef:	b8 05 00 00 00       	mov    $0x5,%eax
     4f4:	e8 9c fe ff ff       	call   395 <testuid>
     4f9:	85 c0                	test   %eax,%eax
     4fb:	74 05                	je     502 <testuidgid+0x65>
    success = -1;
     4fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if (testuid(32767, 32767, 0))
     502:	b9 00 00 00 00       	mov    $0x0,%ecx
     507:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     50c:	b8 ff 7f 00 00       	mov    $0x7fff,%eax
     511:	e8 7f fe ff ff       	call   395 <testuid>
     516:	85 c0                	test   %eax,%eax
     518:	74 05                	je     51f <testuidgid+0x82>
    success = -1;
     51a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if (testuid(32768, 32767, -1))
     51f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
     524:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     529:	b8 00 80 00 00       	mov    $0x8000,%eax
     52e:	e8 62 fe ff ff       	call   395 <testuid>
     533:	85 c0                	test   %eax,%eax
     535:	74 05                	je     53c <testuidgid+0x9f>
    success = -1;
     537:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if (testuid(-1, 32767, -1))
     53c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
     541:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     546:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     54b:	e8 45 fe ff ff       	call   395 <testuid>
     550:	85 c0                	test   %eax,%eax
     552:	74 05                	je     559 <testuidgid+0xbc>
    success = -1;
     554:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  gid = getgid();
     559:	e8 72 08 00 00       	call   dd0 <getgid>
  if(gid < 0 || gid > 32767){
     55e:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
     563:	0f 87 b2 00 00 00    	ja     61b <testuidgid+0x17e>
  if (testgid(0, 0, 0))
     569:	b9 00 00 00 00       	mov    $0x0,%ecx
     56e:	ba 00 00 00 00       	mov    $0x0,%edx
     573:	b8 00 00 00 00       	mov    $0x0,%eax
     578:	e8 9c fe ff ff       	call   419 <testgid>
     57d:	85 c0                	test   %eax,%eax
     57f:	74 05                	je     586 <testuidgid+0xe9>
    success = -1;
     581:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if (testgid(5, 5, 0))
     586:	b9 00 00 00 00       	mov    $0x0,%ecx
     58b:	ba 05 00 00 00       	mov    $0x5,%edx
     590:	b8 05 00 00 00       	mov    $0x5,%eax
     595:	e8 7f fe ff ff       	call   419 <testgid>
     59a:	85 c0                	test   %eax,%eax
     59c:	74 05                	je     5a3 <testuidgid+0x106>
    success = -1;
     59e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if (testgid(32767, 32767, 0))
     5a3:	b9 00 00 00 00       	mov    $0x0,%ecx
     5a8:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     5ad:	b8 ff 7f 00 00       	mov    $0x7fff,%eax
     5b2:	e8 62 fe ff ff       	call   419 <testgid>
     5b7:	85 c0                	test   %eax,%eax
     5b9:	74 05                	je     5c0 <testuidgid+0x123>
    success = -1;
     5bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if (testgid(-1, 32767, -1))
     5c0:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
     5c5:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     5ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     5cf:	e8 45 fe ff ff       	call   419 <testgid>
     5d4:	85 c0                	test   %eax,%eax
     5d6:	74 05                	je     5dd <testuidgid+0x140>
    success = -1;
     5d8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if (testgid(32768, 32767, -1))
     5dd:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
     5e2:	ba ff 7f 00 00       	mov    $0x7fff,%edx
     5e7:	b8 00 80 00 00       	mov    $0x8000,%eax
     5ec:	e8 28 fe ff ff       	call   419 <testgid>
     5f1:	85 c0                	test   %eax,%eax
     5f3:	75 04                	jne    5f9 <testuidgid+0x15c>
  if (success == 0)
     5f5:	85 db                	test   %ebx,%ebx
     5f7:	74 3f                	je     638 <testuidgid+0x19b>
}
     5f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     5fc:	c9                   	leave  
     5fd:	c3                   	ret    
    printf(1, "FAILED: Default UID %d, out of range\n", uid);
     5fe:	83 ec 04             	sub    $0x4,%esp
     601:	50                   	push   %eax
     602:	68 08 15 00 00       	push   $0x1508
     607:	6a 01                	push   $0x1
     609:	e8 9b 08 00 00       	call   ea9 <printf>
     60e:	83 c4 10             	add    $0x10,%esp
    success = -1;
     611:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
     616:	e9 ad fe ff ff       	jmp    4c8 <testuidgid+0x2b>
    printf(1, "FAILED: Default GID %d, out of range\n", gid);
     61b:	83 ec 04             	sub    $0x4,%esp
     61e:	50                   	push   %eax
     61f:	68 30 15 00 00       	push   $0x1530
     624:	6a 01                	push   $0x1
     626:	e8 7e 08 00 00       	call   ea9 <printf>
     62b:	83 c4 10             	add    $0x10,%esp
    success = -1;
     62e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
     633:	e9 31 ff ff ff       	jmp    569 <testuidgid+0xcc>
    printf(1, "** All tests passed! **\n");
     638:	83 ec 08             	sub    $0x8,%esp
     63b:	68 18 17 00 00       	push   $0x1718
     640:	6a 01                	push   $0x1
     642:	e8 62 08 00 00       	call   ea9 <printf>
     647:	83 c4 10             	add    $0x10,%esp
}
     64a:	eb ad                	jmp    5f9 <testuidgid+0x15c>

0000064c <testuidgidinheritance>:
testuidgidinheritance(void){
     64c:	55                   	push   %ebp
     64d:	89 e5                	mov    %esp,%ebp
     64f:	53                   	push   %ebx
     650:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "\n----------\nRunning UID / GID Inheritance Test\n----------\n");
     653:	68 58 15 00 00       	push   $0x1558
     658:	6a 01                	push   $0x1
     65a:	e8 4a 08 00 00       	call   ea9 <printf>
  if (testuid(12345, 12345, 0))
     65f:	b9 00 00 00 00       	mov    $0x0,%ecx
     664:	ba 39 30 00 00       	mov    $0x3039,%edx
     669:	b8 39 30 00 00       	mov    $0x3039,%eax
     66e:	e8 22 fd ff ff       	call   395 <testuid>
     673:	89 c3                	mov    %eax,%ebx
     675:	83 c4 10             	add    $0x10,%esp
     678:	85 c0                	test   %eax,%eax
     67a:	74 05                	je     681 <testuidgidinheritance+0x35>
    success = -1;
     67c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if (testgid(12345, 12345, 0))
     681:	b9 00 00 00 00       	mov    $0x0,%ecx
     686:	ba 39 30 00 00       	mov    $0x3039,%edx
     68b:	b8 39 30 00 00       	mov    $0x3039,%eax
     690:	e8 84 fd ff ff       	call   419 <testgid>
     695:	85 c0                	test   %eax,%eax
     697:	75 04                	jne    69d <testuidgidinheritance+0x51>
  if(success != 0)
     699:	85 db                	test   %ebx,%ebx
     69b:	74 05                	je     6a2 <testuidgidinheritance+0x56>
}
     69d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     6a0:	c9                   	leave  
     6a1:	c3                   	ret    
  ret = fork();
     6a2:	e8 69 06 00 00       	call   d10 <fork>
  if(ret == 0){
     6a7:	85 c0                	test   %eax,%eax
     6a9:	74 07                	je     6b2 <testuidgidinheritance+0x66>
    wait();
     6ab:	e8 70 06 00 00       	call   d20 <wait>
     6b0:	eb eb                	jmp    69d <testuidgidinheritance+0x51>
    uid = getuid();
     6b2:	e8 11 07 00 00       	call   dc8 <getuid>
     6b7:	89 c3                	mov    %eax,%ebx
    gid = getgid();
     6b9:	e8 12 07 00 00       	call   dd0 <getgid>
    if(uid != 12345){
     6be:	81 fb 39 30 00 00    	cmp    $0x3039,%ebx
     6c4:	75 1c                	jne    6e2 <testuidgidinheritance+0x96>
    else if(gid != 12345){
     6c6:	3d 39 30 00 00       	cmp    $0x3039,%eax
     6cb:	74 2d                	je     6fa <testuidgidinheritance+0xae>
      printf(2, "FAILED: Parent GID is 12345, child GID is %d\n", gid);
     6cd:	83 ec 04             	sub    $0x4,%esp
     6d0:	50                   	push   %eax
     6d1:	68 c4 15 00 00       	push   $0x15c4
     6d6:	6a 02                	push   $0x2
     6d8:	e8 cc 07 00 00       	call   ea9 <printf>
     6dd:	83 c4 10             	add    $0x10,%esp
     6e0:	eb 13                	jmp    6f5 <testuidgidinheritance+0xa9>
      printf(2, "FAILED: Parent UID is 12345, child UID is %d\n", uid);
     6e2:	83 ec 04             	sub    $0x4,%esp
     6e5:	53                   	push   %ebx
     6e6:	68 94 15 00 00       	push   $0x1594
     6eb:	6a 02                	push   $0x2
     6ed:	e8 b7 07 00 00       	call   ea9 <printf>
     6f2:	83 c4 10             	add    $0x10,%esp
    exit();
     6f5:	e8 1e 06 00 00       	call   d18 <exit>
      printf(1, "** Test Passed! **\n");
     6fa:	83 ec 08             	sub    $0x8,%esp
     6fd:	68 31 17 00 00       	push   $0x1731
     702:	6a 01                	push   $0x1
     704:	e8 a0 07 00 00       	call   ea9 <printf>
     709:	83 c4 10             	add    $0x10,%esp
     70c:	eb e7                	jmp    6f5 <testuidgidinheritance+0xa9>

0000070e <testppid>:
testppid(void){
     70e:	55                   	push   %ebp
     70f:	89 e5                	mov    %esp,%ebp
     711:	53                   	push   %ebx
     712:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "\n----------\nRunning PPID Test\n----------\n");
     715:	68 f4 15 00 00       	push   $0x15f4
     71a:	6a 01                	push   $0x1
     71c:	e8 88 07 00 00       	call   ea9 <printf>
  pid = getpid();
     721:	e8 72 06 00 00       	call   d98 <getpid>
     726:	89 c3                	mov    %eax,%ebx
  ret = fork();
     728:	e8 e3 05 00 00       	call   d10 <fork>
  if(ret == 0){
     72d:	83 c4 10             	add    $0x10,%esp
     730:	85 c0                	test   %eax,%eax
     732:	74 0a                	je     73e <testppid+0x30>
    wait();
     734:	e8 e7 05 00 00       	call   d20 <wait>
}
     739:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     73c:	c9                   	leave  
     73d:	c3                   	ret    
    ppid = getppid();
     73e:	e8 95 06 00 00       	call   dd8 <getppid>
    if(ppid != pid)
     743:	39 c3                	cmp    %eax,%ebx
     745:	74 16                	je     75d <testppid+0x4f>
      printf(2, "FAILED: Parent PID is %d, Child's PPID is %d\n", pid, ppid);
     747:	50                   	push   %eax
     748:	53                   	push   %ebx
     749:	68 20 16 00 00       	push   $0x1620
     74e:	6a 02                	push   $0x2
     750:	e8 54 07 00 00       	call   ea9 <printf>
     755:	83 c4 10             	add    $0x10,%esp
    exit();
     758:	e8 bb 05 00 00       	call   d18 <exit>
      printf(1, "** Test passed! **\n");
     75d:	83 ec 08             	sub    $0x8,%esp
     760:	68 45 17 00 00       	push   $0x1745
     765:	6a 01                	push   $0x1
     767:	e8 3d 07 00 00       	call   ea9 <printf>
     76c:	83 c4 10             	add    $0x10,%esp
     76f:	eb e7                	jmp    758 <testppid+0x4a>

00000771 <testtimewitharg>:
#endif

#ifdef TIME_TEST
// Forks a process and execs with time + args to see how it handles no args, invalid args, mulitple args
void
testtimewitharg(char **arg){
     771:	f3 0f 1e fb          	endbr32 
     775:	55                   	push   %ebp
     776:	89 e5                	mov    %esp,%ebp
     778:	83 ec 08             	sub    $0x8,%esp
  int ret;

  ret = fork();
     77b:	e8 90 05 00 00       	call   d10 <fork>
  if (ret == 0){
     780:	85 c0                	test   %eax,%eax
     782:	74 0c                	je     790 <testtimewitharg+0x1f>
    exec(arg[0], arg);
    printf(2, "FAILED: exec failed to execute %s\n", arg[0]);
    exit();
  }
  else if(ret == -1){
     784:	83 f8 ff             	cmp    $0xffffffff,%eax
     787:	74 30                	je     7b9 <testtimewitharg+0x48>
    printf(2, "FAILED: fork failed\n");
  }
  else
    wait();
     789:	e8 92 05 00 00       	call   d20 <wait>
}
     78e:	c9                   	leave  
     78f:	c3                   	ret    
    exec(arg[0], arg);
     790:	83 ec 08             	sub    $0x8,%esp
     793:	ff 75 08             	pushl  0x8(%ebp)
     796:	8b 45 08             	mov    0x8(%ebp),%eax
     799:	ff 30                	pushl  (%eax)
     79b:	e8 b0 05 00 00       	call   d50 <exec>
    printf(2, "FAILED: exec failed to execute %s\n", arg[0]);
     7a0:	83 c4 0c             	add    $0xc,%esp
     7a3:	8b 45 08             	mov    0x8(%ebp),%eax
     7a6:	ff 30                	pushl  (%eax)
     7a8:	68 50 16 00 00       	push   $0x1650
     7ad:	6a 02                	push   $0x2
     7af:	e8 f5 06 00 00       	call   ea9 <printf>
    exit();
     7b4:	e8 5f 05 00 00       	call   d18 <exit>
    printf(2, "FAILED: fork failed\n");
     7b9:	83 ec 08             	sub    $0x8,%esp
     7bc:	68 59 17 00 00       	push   $0x1759
     7c1:	6a 02                	push   $0x2
     7c3:	e8 e1 06 00 00       	call   ea9 <printf>
     7c8:	83 c4 10             	add    $0x10,%esp
     7cb:	eb c1                	jmp    78e <testtimewitharg+0x1d>

000007cd <testtime>:
void
testtime(void){
     7cd:	f3 0f 1e fb          	endbr32 
     7d1:	55                   	push   %ebp
     7d2:	89 e5                	mov    %esp,%ebp
     7d4:	57                   	push   %edi
     7d5:	56                   	push   %esi
     7d6:	53                   	push   %ebx
     7d7:	83 ec 28             	sub    $0x28,%esp
  char **arg1 = malloc(sizeof(char *));
     7da:	6a 04                	push   $0x4
     7dc:	e8 f9 08 00 00       	call   10da <malloc>
     7e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char **arg2 = malloc(sizeof(char *)*2);
     7e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     7eb:	e8 ea 08 00 00       	call   10da <malloc>
     7f0:	89 c7                	mov    %eax,%edi
  char **arg3 = malloc(sizeof(char *)*2);
     7f2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     7f9:	e8 dc 08 00 00       	call   10da <malloc>
     7fe:	89 c6                	mov    %eax,%esi
  char **arg4 = malloc(sizeof(char *)*4);
     800:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
     807:	e8 ce 08 00 00       	call   10da <malloc>
     80c:	89 c3                	mov    %eax,%ebx

  // no argument
  arg1[0] = malloc(sizeof(char) * 5);
     80e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     815:	e8 c0 08 00 00       	call   10da <malloc>
     81a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     81d:	89 02                	mov    %eax,(%edx)
  strcpy(arg1[0], "time");
     81f:	83 c4 08             	add    $0x8,%esp
     822:	68 6e 17 00 00       	push   $0x176e
     827:	50                   	push   %eax
     828:	e8 55 02 00 00       	call   a82 <strcpy>

  // single arg (fails)
  arg2[0] = malloc(sizeof(char) * 5);
     82d:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     834:	e8 a1 08 00 00       	call   10da <malloc>
     839:	89 07                	mov    %eax,(%edi)
  strcpy(arg2[0], "time");
     83b:	83 c4 08             	add    $0x8,%esp
     83e:	68 6e 17 00 00       	push   $0x176e
     843:	50                   	push   %eax
     844:	e8 39 02 00 00       	call   a82 <strcpy>
  arg2[1] = malloc(sizeof(char) * 4);
     849:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     850:	e8 85 08 00 00       	call   10da <malloc>
     855:	89 47 04             	mov    %eax,0x4(%edi)
  strcpy(arg2[1], "abc");
     858:	83 c4 08             	add    $0x8,%esp
     85b:	68 73 17 00 00       	push   $0x1773
     860:	50                   	push   %eax
     861:	e8 1c 02 00 00       	call   a82 <strcpy>

  // single arg (succeeds)
  arg3[0] = malloc(sizeof(char) * 5);
     866:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     86d:	e8 68 08 00 00       	call   10da <malloc>
     872:	89 06                	mov    %eax,(%esi)
  strcpy(arg3[0], "time");
     874:	83 c4 08             	add    $0x8,%esp
     877:	68 6e 17 00 00       	push   $0x176e
     87c:	50                   	push   %eax
     87d:	e8 00 02 00 00       	call   a82 <strcpy>
  arg3[1] = malloc(sizeof(char) * 5);
     882:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     889:	e8 4c 08 00 00       	call   10da <malloc>
     88e:	89 46 04             	mov    %eax,0x4(%esi)
  strcpy(arg3[1], "date");
     891:	83 c4 08             	add    $0x8,%esp
     894:	68 77 17 00 00       	push   $0x1777
     899:	50                   	push   %eax
     89a:	e8 e3 01 00 00       	call   a82 <strcpy>

  // multi arg (succeeds)
  arg4[0] = malloc(sizeof(char) * 5);
     89f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     8a6:	e8 2f 08 00 00       	call   10da <malloc>
     8ab:	89 03                	mov    %eax,(%ebx)
  strcpy(arg4[0], "time");
     8ad:	83 c4 08             	add    $0x8,%esp
     8b0:	68 6e 17 00 00       	push   $0x176e
     8b5:	50                   	push   %eax
     8b6:	e8 c7 01 00 00       	call   a82 <strcpy>
  arg4[1] = malloc(sizeof(char) * 5);
     8bb:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     8c2:	e8 13 08 00 00       	call   10da <malloc>
     8c7:	89 43 04             	mov    %eax,0x4(%ebx)
  strcpy(arg4[1], "time");
     8ca:	83 c4 08             	add    $0x8,%esp
     8cd:	68 6e 17 00 00       	push   $0x176e
     8d2:	50                   	push   %eax
     8d3:	e8 aa 01 00 00       	call   a82 <strcpy>
  arg4[2] = malloc(sizeof(char) * 5);
     8d8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     8df:	e8 f6 07 00 00       	call   10da <malloc>
     8e4:	89 43 08             	mov    %eax,0x8(%ebx)
  strcpy(arg4[2], "echo");
     8e7:	83 c4 08             	add    $0x8,%esp
     8ea:	68 7c 17 00 00       	push   $0x177c
     8ef:	50                   	push   %eax
     8f0:	e8 8d 01 00 00       	call   a82 <strcpy>
  arg4[3] = malloc(sizeof(char) * 6);
     8f5:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
     8fc:	e8 d9 07 00 00       	call   10da <malloc>
     901:	89 43 0c             	mov    %eax,0xc(%ebx)
  strcpy(arg4[3], "\"abc\"");
     904:	83 c4 08             	add    $0x8,%esp
     907:	68 81 17 00 00       	push   $0x1781
     90c:	50                   	push   %eax
     90d:	e8 70 01 00 00       	call   a82 <strcpy>

  printf(1, "\n----------\nRunning Time Test\n----------\n");
     912:	83 c4 08             	add    $0x8,%esp
     915:	68 74 16 00 00       	push   $0x1674
     91a:	6a 01                	push   $0x1
     91c:	e8 88 05 00 00       	call   ea9 <printf>
  printf(1, "You will need to verify these tests passed\n");
     921:	83 c4 08             	add    $0x8,%esp
     924:	68 a0 16 00 00       	push   $0x16a0
     929:	6a 01                	push   $0x1
     92b:	e8 79 05 00 00       	call   ea9 <printf>

  printf(1,"\n%s\n", arg1[0]);
     930:	83 c4 0c             	add    $0xc,%esp
     933:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     936:	ff 32                	pushl  (%edx)
     938:	68 87 17 00 00       	push   $0x1787
     93d:	6a 01                	push   $0x1
     93f:	e8 65 05 00 00       	call   ea9 <printf>
  testtimewitharg(arg1);
     944:	83 c4 04             	add    $0x4,%esp
     947:	ff 75 e4             	pushl  -0x1c(%ebp)
     94a:	e8 22 fe ff ff       	call   771 <testtimewitharg>
  printf(1,"\n%s %s\n", arg2[0], arg2[1]);
     94f:	ff 77 04             	pushl  0x4(%edi)
     952:	ff 37                	pushl  (%edi)
     954:	68 8c 17 00 00       	push   $0x178c
     959:	6a 01                	push   $0x1
     95b:	e8 49 05 00 00       	call   ea9 <printf>
  testtimewitharg(arg2);
     960:	83 c4 14             	add    $0x14,%esp
     963:	57                   	push   %edi
     964:	e8 08 fe ff ff       	call   771 <testtimewitharg>
  printf(1,"\n%s %s\n", arg3[0], arg3[1]);
     969:	ff 76 04             	pushl  0x4(%esi)
     96c:	ff 36                	pushl  (%esi)
     96e:	68 8c 17 00 00       	push   $0x178c
     973:	6a 01                	push   $0x1
     975:	e8 2f 05 00 00       	call   ea9 <printf>
  testtimewitharg(arg3);
     97a:	83 c4 14             	add    $0x14,%esp
     97d:	56                   	push   %esi
     97e:	e8 ee fd ff ff       	call   771 <testtimewitharg>
  printf(1,"\n%s %s %s %s\n", arg4[0], arg4[1], arg4[2], arg4[3]);
     983:	83 c4 08             	add    $0x8,%esp
     986:	ff 73 0c             	pushl  0xc(%ebx)
     989:	ff 73 08             	pushl  0x8(%ebx)
     98c:	ff 73 04             	pushl  0x4(%ebx)
     98f:	ff 33                	pushl  (%ebx)
     991:	68 94 17 00 00       	push   $0x1794
     996:	6a 01                	push   $0x1
     998:	e8 0c 05 00 00       	call   ea9 <printf>
  testtimewitharg(arg4);
     99d:	83 c4 14             	add    $0x14,%esp
     9a0:	53                   	push   %ebx
     9a1:	e8 cb fd ff ff       	call   771 <testtimewitharg>

  free(arg1[0]);
     9a6:	83 c4 04             	add    $0x4,%esp
     9a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     9ac:	ff 32                	pushl  (%edx)
     9ae:	e8 63 06 00 00       	call   1016 <free>
  free(arg1);
     9b3:	83 c4 04             	add    $0x4,%esp
     9b6:	ff 75 e4             	pushl  -0x1c(%ebp)
     9b9:	e8 58 06 00 00       	call   1016 <free>
  free(arg2[0]); free(arg2[1]);
     9be:	83 c4 04             	add    $0x4,%esp
     9c1:	ff 37                	pushl  (%edi)
     9c3:	e8 4e 06 00 00       	call   1016 <free>
     9c8:	83 c4 04             	add    $0x4,%esp
     9cb:	ff 77 04             	pushl  0x4(%edi)
     9ce:	e8 43 06 00 00       	call   1016 <free>
  free(arg2);
     9d3:	89 3c 24             	mov    %edi,(%esp)
     9d6:	e8 3b 06 00 00       	call   1016 <free>
  free(arg3[0]); free(arg3[1]);
     9db:	83 c4 04             	add    $0x4,%esp
     9de:	ff 36                	pushl  (%esi)
     9e0:	e8 31 06 00 00       	call   1016 <free>
     9e5:	83 c4 04             	add    $0x4,%esp
     9e8:	ff 76 04             	pushl  0x4(%esi)
     9eb:	e8 26 06 00 00       	call   1016 <free>
  free(arg3);
     9f0:	89 34 24             	mov    %esi,(%esp)
     9f3:	e8 1e 06 00 00       	call   1016 <free>
  free(arg4[0]); free(arg4[1]); free(arg4[2]); free(arg4[3]);
     9f8:	83 c4 04             	add    $0x4,%esp
     9fb:	ff 33                	pushl  (%ebx)
     9fd:	e8 14 06 00 00       	call   1016 <free>
     a02:	83 c4 04             	add    $0x4,%esp
     a05:	ff 73 04             	pushl  0x4(%ebx)
     a08:	e8 09 06 00 00       	call   1016 <free>
     a0d:	83 c4 04             	add    $0x4,%esp
     a10:	ff 73 08             	pushl  0x8(%ebx)
     a13:	e8 fe 05 00 00       	call   1016 <free>
     a18:	83 c4 04             	add    $0x4,%esp
     a1b:	ff 73 0c             	pushl  0xc(%ebx)
     a1e:	e8 f3 05 00 00       	call   1016 <free>
  free(arg4);
     a23:	89 1c 24             	mov    %ebx,(%esp)
     a26:	e8 eb 05 00 00       	call   1016 <free>
}
     a2b:	83 c4 10             	add    $0x10,%esp
     a2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a31:	5b                   	pop    %ebx
     a32:	5e                   	pop    %esi
     a33:	5f                   	pop    %edi
     a34:	5d                   	pop    %ebp
     a35:	c3                   	ret    

00000a36 <main>:
#endif

int
main(int argc, char *argv[])
{
     a36:	f3 0f 1e fb          	endbr32 
     a3a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     a3e:	83 e4 f0             	and    $0xfffffff0,%esp
     a41:	ff 71 fc             	pushl  -0x4(%ecx)
     a44:	55                   	push   %ebp
     a45:	89 e5                	mov    %esp,%ebp
     a47:	51                   	push   %ecx
     a48:	83 ec 04             	sub    $0x4,%esp
     a4b:	8b 41 04             	mov    0x4(%ecx),%eax
  #ifdef CPUTIME_TEST
  testcputime(argv[0]);
     a4e:	8b 00                	mov    (%eax),%eax
     a50:	e8 df f7 ff ff       	call   234 <testcputime>
  #endif
  #ifdef UIDGIDPPID_TEST
  testuidgid();
     a55:	e8 43 fa ff ff       	call   49d <testuidgid>
  testuidgidinheritance();
     a5a:	e8 ed fb ff ff       	call   64c <testuidgidinheritance>
  testppid();
     a5f:	e8 aa fc ff ff       	call   70e <testppid>
  #endif
  #ifdef GETPROCS_TEST
  testgetprocs();  // no need to pass argv[0]
     a64:	e8 a2 f6 ff ff       	call   10b <testgetprocs>
  #endif
  #ifdef TIME_TEST
  testtime();
     a69:	e8 5f fd ff ff       	call   7cd <testtime>
  #endif
  printf(1, "\n** End of Tests **\n");
     a6e:	83 ec 08             	sub    $0x8,%esp
     a71:	68 a2 17 00 00       	push   $0x17a2
     a76:	6a 01                	push   $0x1
     a78:	e8 2c 04 00 00       	call   ea9 <printf>
  exit();
     a7d:	e8 96 02 00 00       	call   d18 <exit>

00000a82 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     a82:	f3 0f 1e fb          	endbr32 
     a86:	55                   	push   %ebp
     a87:	89 e5                	mov    %esp,%ebp
     a89:	56                   	push   %esi
     a8a:	53                   	push   %ebx
     a8b:	8b 75 08             	mov    0x8(%ebp),%esi
     a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     a91:	89 f0                	mov    %esi,%eax
     a93:	89 d1                	mov    %edx,%ecx
     a95:	83 c2 01             	add    $0x1,%edx
     a98:	89 c3                	mov    %eax,%ebx
     a9a:	83 c0 01             	add    $0x1,%eax
     a9d:	0f b6 09             	movzbl (%ecx),%ecx
     aa0:	88 0b                	mov    %cl,(%ebx)
     aa2:	84 c9                	test   %cl,%cl
     aa4:	75 ed                	jne    a93 <strcpy+0x11>
    ;
  return os;
}
     aa6:	89 f0                	mov    %esi,%eax
     aa8:	5b                   	pop    %ebx
     aa9:	5e                   	pop    %esi
     aaa:	5d                   	pop    %ebp
     aab:	c3                   	ret    

00000aac <strcmp>:

int
strcmp(const char *p, const char *q)
{
     aac:	f3 0f 1e fb          	endbr32 
     ab0:	55                   	push   %ebp
     ab1:	89 e5                	mov    %esp,%ebp
     ab3:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     ab9:	0f b6 01             	movzbl (%ecx),%eax
     abc:	84 c0                	test   %al,%al
     abe:	74 0c                	je     acc <strcmp+0x20>
     ac0:	3a 02                	cmp    (%edx),%al
     ac2:	75 08                	jne    acc <strcmp+0x20>
    p++, q++;
     ac4:	83 c1 01             	add    $0x1,%ecx
     ac7:	83 c2 01             	add    $0x1,%edx
     aca:	eb ed                	jmp    ab9 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
     acc:	0f b6 c0             	movzbl %al,%eax
     acf:	0f b6 12             	movzbl (%edx),%edx
     ad2:	29 d0                	sub    %edx,%eax
}
     ad4:	5d                   	pop    %ebp
     ad5:	c3                   	ret    

00000ad6 <strlen>:

uint
strlen(char *s)
{
     ad6:	f3 0f 1e fb          	endbr32 
     ada:	55                   	push   %ebp
     adb:	89 e5                	mov    %esp,%ebp
     add:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     ae0:	b8 00 00 00 00       	mov    $0x0,%eax
     ae5:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
     ae9:	74 05                	je     af0 <strlen+0x1a>
     aeb:	83 c0 01             	add    $0x1,%eax
     aee:	eb f5                	jmp    ae5 <strlen+0xf>
    ;
  return n;
}
     af0:	5d                   	pop    %ebp
     af1:	c3                   	ret    

00000af2 <memset>:

void*
memset(void *dst, int c, uint n)
{
     af2:	f3 0f 1e fb          	endbr32 
     af6:	55                   	push   %ebp
     af7:	89 e5                	mov    %esp,%ebp
     af9:	57                   	push   %edi
     afa:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     afd:	89 d7                	mov    %edx,%edi
     aff:	8b 4d 10             	mov    0x10(%ebp),%ecx
     b02:	8b 45 0c             	mov    0xc(%ebp),%eax
     b05:	fc                   	cld    
     b06:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     b08:	89 d0                	mov    %edx,%eax
     b0a:	5f                   	pop    %edi
     b0b:	5d                   	pop    %ebp
     b0c:	c3                   	ret    

00000b0d <strchr>:

char*
strchr(const char *s, char c)
{
     b0d:	f3 0f 1e fb          	endbr32 
     b11:	55                   	push   %ebp
     b12:	89 e5                	mov    %esp,%ebp
     b14:	8b 45 08             	mov    0x8(%ebp),%eax
     b17:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     b1b:	0f b6 10             	movzbl (%eax),%edx
     b1e:	84 d2                	test   %dl,%dl
     b20:	74 09                	je     b2b <strchr+0x1e>
    if(*s == c)
     b22:	38 ca                	cmp    %cl,%dl
     b24:	74 0a                	je     b30 <strchr+0x23>
  for(; *s; s++)
     b26:	83 c0 01             	add    $0x1,%eax
     b29:	eb f0                	jmp    b1b <strchr+0xe>
      return (char*)s;
  return 0;
     b2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     b30:	5d                   	pop    %ebp
     b31:	c3                   	ret    

00000b32 <gets>:

char*
gets(char *buf, int max)
{
     b32:	f3 0f 1e fb          	endbr32 
     b36:	55                   	push   %ebp
     b37:	89 e5                	mov    %esp,%ebp
     b39:	57                   	push   %edi
     b3a:	56                   	push   %esi
     b3b:	53                   	push   %ebx
     b3c:	83 ec 1c             	sub    $0x1c,%esp
     b3f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     b42:	bb 00 00 00 00       	mov    $0x0,%ebx
     b47:	89 de                	mov    %ebx,%esi
     b49:	83 c3 01             	add    $0x1,%ebx
     b4c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     b4f:	7d 2e                	jge    b7f <gets+0x4d>
    cc = read(0, &c, 1);
     b51:	83 ec 04             	sub    $0x4,%esp
     b54:	6a 01                	push   $0x1
     b56:	8d 45 e7             	lea    -0x19(%ebp),%eax
     b59:	50                   	push   %eax
     b5a:	6a 00                	push   $0x0
     b5c:	e8 cf 01 00 00       	call   d30 <read>
    if(cc < 1)
     b61:	83 c4 10             	add    $0x10,%esp
     b64:	85 c0                	test   %eax,%eax
     b66:	7e 17                	jle    b7f <gets+0x4d>
      break;
    buf[i++] = c;
     b68:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     b6c:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
     b6f:	3c 0a                	cmp    $0xa,%al
     b71:	0f 94 c2             	sete   %dl
     b74:	3c 0d                	cmp    $0xd,%al
     b76:	0f 94 c0             	sete   %al
     b79:	08 c2                	or     %al,%dl
     b7b:	74 ca                	je     b47 <gets+0x15>
    buf[i++] = c;
     b7d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
     b7f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
     b83:	89 f8                	mov    %edi,%eax
     b85:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b88:	5b                   	pop    %ebx
     b89:	5e                   	pop    %esi
     b8a:	5f                   	pop    %edi
     b8b:	5d                   	pop    %ebp
     b8c:	c3                   	ret    

00000b8d <stat>:

int
stat(char *n, struct stat *st)
{
     b8d:	f3 0f 1e fb          	endbr32 
     b91:	55                   	push   %ebp
     b92:	89 e5                	mov    %esp,%ebp
     b94:	56                   	push   %esi
     b95:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b96:	83 ec 08             	sub    $0x8,%esp
     b99:	6a 00                	push   $0x0
     b9b:	ff 75 08             	pushl  0x8(%ebp)
     b9e:	e8 b5 01 00 00       	call   d58 <open>
  if(fd < 0)
     ba3:	83 c4 10             	add    $0x10,%esp
     ba6:	85 c0                	test   %eax,%eax
     ba8:	78 24                	js     bce <stat+0x41>
     baa:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
     bac:	83 ec 08             	sub    $0x8,%esp
     baf:	ff 75 0c             	pushl  0xc(%ebp)
     bb2:	50                   	push   %eax
     bb3:	e8 b8 01 00 00       	call   d70 <fstat>
     bb8:	89 c6                	mov    %eax,%esi
  close(fd);
     bba:	89 1c 24             	mov    %ebx,(%esp)
     bbd:	e8 7e 01 00 00       	call   d40 <close>
  return r;
     bc2:	83 c4 10             	add    $0x10,%esp
}
     bc5:	89 f0                	mov    %esi,%eax
     bc7:	8d 65 f8             	lea    -0x8(%ebp),%esp
     bca:	5b                   	pop    %ebx
     bcb:	5e                   	pop    %esi
     bcc:	5d                   	pop    %ebp
     bcd:	c3                   	ret    
    return -1;
     bce:	be ff ff ff ff       	mov    $0xffffffff,%esi
     bd3:	eb f0                	jmp    bc5 <stat+0x38>

00000bd5 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
     bd5:	f3 0f 1e fb          	endbr32 
     bd9:	55                   	push   %ebp
     bda:	89 e5                	mov    %esp,%ebp
     bdc:	57                   	push   %edi
     bdd:	56                   	push   %esi
     bde:	53                   	push   %ebx
     bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
     be2:	0f b6 02             	movzbl (%edx),%eax
     be5:	3c 20                	cmp    $0x20,%al
     be7:	75 05                	jne    bee <atoi+0x19>
     be9:	83 c2 01             	add    $0x1,%edx
     bec:	eb f4                	jmp    be2 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
     bee:	3c 2d                	cmp    $0x2d,%al
     bf0:	74 1d                	je     c0f <atoi+0x3a>
     bf2:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
     bf7:	3c 2b                	cmp    $0x2b,%al
     bf9:	0f 94 c1             	sete   %cl
     bfc:	3c 2d                	cmp    $0x2d,%al
     bfe:	0f 94 c0             	sete   %al
     c01:	08 c1                	or     %al,%cl
     c03:	74 03                	je     c08 <atoi+0x33>
    s++;
     c05:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
     c08:	b8 00 00 00 00       	mov    $0x0,%eax
     c0d:	eb 17                	jmp    c26 <atoi+0x51>
     c0f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
     c14:	eb e1                	jmp    bf7 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
     c16:	8d 34 80             	lea    (%eax,%eax,4),%esi
     c19:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
     c1c:	83 c2 01             	add    $0x1,%edx
     c1f:	0f be c9             	movsbl %cl,%ecx
     c22:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
     c26:	0f b6 0a             	movzbl (%edx),%ecx
     c29:	8d 59 d0             	lea    -0x30(%ecx),%ebx
     c2c:	80 fb 09             	cmp    $0x9,%bl
     c2f:	76 e5                	jbe    c16 <atoi+0x41>
  return sign*n;
     c31:	0f af c7             	imul   %edi,%eax
}
     c34:	5b                   	pop    %ebx
     c35:	5e                   	pop    %esi
     c36:	5f                   	pop    %edi
     c37:	5d                   	pop    %ebp
     c38:	c3                   	ret    

00000c39 <atoo>:

int
atoo(const char *s)
{
     c39:	f3 0f 1e fb          	endbr32 
     c3d:	55                   	push   %ebp
     c3e:	89 e5                	mov    %esp,%ebp
     c40:	57                   	push   %edi
     c41:	56                   	push   %esi
     c42:	53                   	push   %ebx
     c43:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
     c46:	0f b6 0a             	movzbl (%edx),%ecx
     c49:	80 f9 20             	cmp    $0x20,%cl
     c4c:	75 05                	jne    c53 <atoo+0x1a>
     c4e:	83 c2 01             	add    $0x1,%edx
     c51:	eb f3                	jmp    c46 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
     c53:	80 f9 2d             	cmp    $0x2d,%cl
     c56:	74 23                	je     c7b <atoo+0x42>
     c58:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
     c5d:	80 f9 2b             	cmp    $0x2b,%cl
     c60:	0f 94 c0             	sete   %al
     c63:	89 c6                	mov    %eax,%esi
     c65:	80 f9 2d             	cmp    $0x2d,%cl
     c68:	0f 94 c0             	sete   %al
     c6b:	89 f3                	mov    %esi,%ebx
     c6d:	08 c3                	or     %al,%bl
     c6f:	74 03                	je     c74 <atoo+0x3b>
    s++;
     c71:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
     c74:	b8 00 00 00 00       	mov    $0x0,%eax
     c79:	eb 11                	jmp    c8c <atoo+0x53>
     c7b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
     c80:	eb db                	jmp    c5d <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
     c82:	83 c2 01             	add    $0x1,%edx
     c85:	0f be c9             	movsbl %cl,%ecx
     c88:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
     c8c:	0f b6 0a             	movzbl (%edx),%ecx
     c8f:	8d 59 d0             	lea    -0x30(%ecx),%ebx
     c92:	80 fb 07             	cmp    $0x7,%bl
     c95:	76 eb                	jbe    c82 <atoo+0x49>
  return sign*n;
     c97:	0f af c7             	imul   %edi,%eax
}
     c9a:	5b                   	pop    %ebx
     c9b:	5e                   	pop    %esi
     c9c:	5f                   	pop    %edi
     c9d:	5d                   	pop    %ebp
     c9e:	c3                   	ret    

00000c9f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     c9f:	f3 0f 1e fb          	endbr32 
     ca3:	55                   	push   %ebp
     ca4:	89 e5                	mov    %esp,%ebp
     ca6:	53                   	push   %ebx
     ca7:	8b 55 08             	mov    0x8(%ebp),%edx
     caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
     cad:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
     cb0:	eb 09                	jmp    cbb <strncmp+0x1c>
      n--, p++, q++;
     cb2:	83 e8 01             	sub    $0x1,%eax
     cb5:	83 c2 01             	add    $0x1,%edx
     cb8:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
     cbb:	85 c0                	test   %eax,%eax
     cbd:	74 0b                	je     cca <strncmp+0x2b>
     cbf:	0f b6 1a             	movzbl (%edx),%ebx
     cc2:	84 db                	test   %bl,%bl
     cc4:	74 04                	je     cca <strncmp+0x2b>
     cc6:	3a 19                	cmp    (%ecx),%bl
     cc8:	74 e8                	je     cb2 <strncmp+0x13>
    if(n == 0)
     cca:	85 c0                	test   %eax,%eax
     ccc:	74 0b                	je     cd9 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
     cce:	0f b6 02             	movzbl (%edx),%eax
     cd1:	0f b6 11             	movzbl (%ecx),%edx
     cd4:	29 d0                	sub    %edx,%eax
}
     cd6:	5b                   	pop    %ebx
     cd7:	5d                   	pop    %ebp
     cd8:	c3                   	ret    
      return 0;
     cd9:	b8 00 00 00 00       	mov    $0x0,%eax
     cde:	eb f6                	jmp    cd6 <strncmp+0x37>

00000ce0 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
     ce0:	f3 0f 1e fb          	endbr32 
     ce4:	55                   	push   %ebp
     ce5:	89 e5                	mov    %esp,%ebp
     ce7:	56                   	push   %esi
     ce8:	53                   	push   %ebx
     ce9:	8b 75 08             	mov    0x8(%ebp),%esi
     cec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
     cef:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
     cf2:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
     cf4:	8d 58 ff             	lea    -0x1(%eax),%ebx
     cf7:	85 c0                	test   %eax,%eax
     cf9:	7e 0f                	jle    d0a <memmove+0x2a>
    *dst++ = *src++;
     cfb:	0f b6 01             	movzbl (%ecx),%eax
     cfe:	88 02                	mov    %al,(%edx)
     d00:	8d 49 01             	lea    0x1(%ecx),%ecx
     d03:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
     d06:	89 d8                	mov    %ebx,%eax
     d08:	eb ea                	jmp    cf4 <memmove+0x14>
  return vdst;
}
     d0a:	89 f0                	mov    %esi,%eax
     d0c:	5b                   	pop    %ebx
     d0d:	5e                   	pop    %esi
     d0e:	5d                   	pop    %ebp
     d0f:	c3                   	ret    

00000d10 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d10:	b8 01 00 00 00       	mov    $0x1,%eax
     d15:	cd 40                	int    $0x40
     d17:	c3                   	ret    

00000d18 <exit>:
SYSCALL(exit)
     d18:	b8 02 00 00 00       	mov    $0x2,%eax
     d1d:	cd 40                	int    $0x40
     d1f:	c3                   	ret    

00000d20 <wait>:
SYSCALL(wait)
     d20:	b8 03 00 00 00       	mov    $0x3,%eax
     d25:	cd 40                	int    $0x40
     d27:	c3                   	ret    

00000d28 <pipe>:
SYSCALL(pipe)
     d28:	b8 04 00 00 00       	mov    $0x4,%eax
     d2d:	cd 40                	int    $0x40
     d2f:	c3                   	ret    

00000d30 <read>:
SYSCALL(read)
     d30:	b8 05 00 00 00       	mov    $0x5,%eax
     d35:	cd 40                	int    $0x40
     d37:	c3                   	ret    

00000d38 <write>:
SYSCALL(write)
     d38:	b8 10 00 00 00       	mov    $0x10,%eax
     d3d:	cd 40                	int    $0x40
     d3f:	c3                   	ret    

00000d40 <close>:
SYSCALL(close)
     d40:	b8 15 00 00 00       	mov    $0x15,%eax
     d45:	cd 40                	int    $0x40
     d47:	c3                   	ret    

00000d48 <kill>:
SYSCALL(kill)
     d48:	b8 06 00 00 00       	mov    $0x6,%eax
     d4d:	cd 40                	int    $0x40
     d4f:	c3                   	ret    

00000d50 <exec>:
SYSCALL(exec)
     d50:	b8 07 00 00 00       	mov    $0x7,%eax
     d55:	cd 40                	int    $0x40
     d57:	c3                   	ret    

00000d58 <open>:
SYSCALL(open)
     d58:	b8 0f 00 00 00       	mov    $0xf,%eax
     d5d:	cd 40                	int    $0x40
     d5f:	c3                   	ret    

00000d60 <mknod>:
SYSCALL(mknod)
     d60:	b8 11 00 00 00       	mov    $0x11,%eax
     d65:	cd 40                	int    $0x40
     d67:	c3                   	ret    

00000d68 <unlink>:
SYSCALL(unlink)
     d68:	b8 12 00 00 00       	mov    $0x12,%eax
     d6d:	cd 40                	int    $0x40
     d6f:	c3                   	ret    

00000d70 <fstat>:
SYSCALL(fstat)
     d70:	b8 08 00 00 00       	mov    $0x8,%eax
     d75:	cd 40                	int    $0x40
     d77:	c3                   	ret    

00000d78 <link>:
SYSCALL(link)
     d78:	b8 13 00 00 00       	mov    $0x13,%eax
     d7d:	cd 40                	int    $0x40
     d7f:	c3                   	ret    

00000d80 <mkdir>:
SYSCALL(mkdir)
     d80:	b8 14 00 00 00       	mov    $0x14,%eax
     d85:	cd 40                	int    $0x40
     d87:	c3                   	ret    

00000d88 <chdir>:
SYSCALL(chdir)
     d88:	b8 09 00 00 00       	mov    $0x9,%eax
     d8d:	cd 40                	int    $0x40
     d8f:	c3                   	ret    

00000d90 <dup>:
SYSCALL(dup)
     d90:	b8 0a 00 00 00       	mov    $0xa,%eax
     d95:	cd 40                	int    $0x40
     d97:	c3                   	ret    

00000d98 <getpid>:
SYSCALL(getpid)
     d98:	b8 0b 00 00 00       	mov    $0xb,%eax
     d9d:	cd 40                	int    $0x40
     d9f:	c3                   	ret    

00000da0 <sbrk>:
SYSCALL(sbrk)
     da0:	b8 0c 00 00 00       	mov    $0xc,%eax
     da5:	cd 40                	int    $0x40
     da7:	c3                   	ret    

00000da8 <sleep>:
SYSCALL(sleep)
     da8:	b8 0d 00 00 00       	mov    $0xd,%eax
     dad:	cd 40                	int    $0x40
     daf:	c3                   	ret    

00000db0 <uptime>:
SYSCALL(uptime)
     db0:	b8 0e 00 00 00       	mov    $0xe,%eax
     db5:	cd 40                	int    $0x40
     db7:	c3                   	ret    

00000db8 <halt>:
SYSCALL(halt)
     db8:	b8 16 00 00 00       	mov    $0x16,%eax
     dbd:	cd 40                	int    $0x40
     dbf:	c3                   	ret    

00000dc0 <date>:
SYSCALL(date)
     dc0:	b8 17 00 00 00       	mov    $0x17,%eax
     dc5:	cd 40                	int    $0x40
     dc7:	c3                   	ret    

00000dc8 <getuid>:
SYSCALL(getuid)
     dc8:	b8 18 00 00 00       	mov    $0x18,%eax
     dcd:	cd 40                	int    $0x40
     dcf:	c3                   	ret    

00000dd0 <getgid>:
SYSCALL(getgid)
     dd0:	b8 19 00 00 00       	mov    $0x19,%eax
     dd5:	cd 40                	int    $0x40
     dd7:	c3                   	ret    

00000dd8 <getppid>:
SYSCALL(getppid)
     dd8:	b8 1a 00 00 00       	mov    $0x1a,%eax
     ddd:	cd 40                	int    $0x40
     ddf:	c3                   	ret    

00000de0 <setuid>:
SYSCALL(setuid)
     de0:	b8 1b 00 00 00       	mov    $0x1b,%eax
     de5:	cd 40                	int    $0x40
     de7:	c3                   	ret    

00000de8 <setgid>:
SYSCALL(setgid)
     de8:	b8 1c 00 00 00       	mov    $0x1c,%eax
     ded:	cd 40                	int    $0x40
     def:	c3                   	ret    

00000df0 <getprocs>:
SYSCALL(getprocs)
     df0:	b8 1d 00 00 00       	mov    $0x1d,%eax
     df5:	cd 40                	int    $0x40
     df7:	c3                   	ret    

00000df8 <setpriority>:
SYSCALL(setpriority)
     df8:	b8 1e 00 00 00       	mov    $0x1e,%eax
     dfd:	cd 40                	int    $0x40
     dff:	c3                   	ret    

00000e00 <getpriority>:
SYSCALL(getpriority)
     e00:	b8 1f 00 00 00       	mov    $0x1f,%eax
     e05:	cd 40                	int    $0x40
     e07:	c3                   	ret    

00000e08 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     e08:	55                   	push   %ebp
     e09:	89 e5                	mov    %esp,%ebp
     e0b:	83 ec 1c             	sub    $0x1c,%esp
     e0e:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
     e11:	6a 01                	push   $0x1
     e13:	8d 55 f4             	lea    -0xc(%ebp),%edx
     e16:	52                   	push   %edx
     e17:	50                   	push   %eax
     e18:	e8 1b ff ff ff       	call   d38 <write>
}
     e1d:	83 c4 10             	add    $0x10,%esp
     e20:	c9                   	leave  
     e21:	c3                   	ret    

00000e22 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e22:	55                   	push   %ebp
     e23:	89 e5                	mov    %esp,%ebp
     e25:	57                   	push   %edi
     e26:	56                   	push   %esi
     e27:	53                   	push   %ebx
     e28:	83 ec 2c             	sub    $0x2c,%esp
     e2b:	89 45 d0             	mov    %eax,-0x30(%ebp)
     e2e:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e34:	0f 95 c2             	setne  %dl
     e37:	89 f0                	mov    %esi,%eax
     e39:	c1 e8 1f             	shr    $0x1f,%eax
     e3c:	84 c2                	test   %al,%dl
     e3e:	74 42                	je     e82 <printint+0x60>
    neg = 1;
    x = -xx;
     e40:	f7 de                	neg    %esi
    neg = 1;
     e42:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     e49:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
     e4e:	89 f0                	mov    %esi,%eax
     e50:	ba 00 00 00 00       	mov    $0x0,%edx
     e55:	f7 f1                	div    %ecx
     e57:	89 df                	mov    %ebx,%edi
     e59:	83 c3 01             	add    $0x1,%ebx
     e5c:	0f b6 92 f0 17 00 00 	movzbl 0x17f0(%edx),%edx
     e63:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
     e67:	89 f2                	mov    %esi,%edx
     e69:	89 c6                	mov    %eax,%esi
     e6b:	39 d1                	cmp    %edx,%ecx
     e6d:	76 df                	jbe    e4e <printint+0x2c>
  if(neg)
     e6f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
     e73:	74 2f                	je     ea4 <printint+0x82>
    buf[i++] = '-';
     e75:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
     e7a:	8d 5f 02             	lea    0x2(%edi),%ebx
     e7d:	8b 75 d0             	mov    -0x30(%ebp),%esi
     e80:	eb 15                	jmp    e97 <printint+0x75>
  neg = 0;
     e82:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     e89:	eb be                	jmp    e49 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
     e8b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
     e90:	89 f0                	mov    %esi,%eax
     e92:	e8 71 ff ff ff       	call   e08 <putc>
  while(--i >= 0)
     e97:	83 eb 01             	sub    $0x1,%ebx
     e9a:	79 ef                	jns    e8b <printint+0x69>
}
     e9c:	83 c4 2c             	add    $0x2c,%esp
     e9f:	5b                   	pop    %ebx
     ea0:	5e                   	pop    %esi
     ea1:	5f                   	pop    %edi
     ea2:	5d                   	pop    %ebp
     ea3:	c3                   	ret    
     ea4:	8b 75 d0             	mov    -0x30(%ebp),%esi
     ea7:	eb ee                	jmp    e97 <printint+0x75>

00000ea9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     ea9:	f3 0f 1e fb          	endbr32 
     ead:	55                   	push   %ebp
     eae:	89 e5                	mov    %esp,%ebp
     eb0:	57                   	push   %edi
     eb1:	56                   	push   %esi
     eb2:	53                   	push   %ebx
     eb3:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
     eb6:	8d 45 10             	lea    0x10(%ebp),%eax
     eb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
     ebc:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
     ec1:	bb 00 00 00 00       	mov    $0x0,%ebx
     ec6:	eb 14                	jmp    edc <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
     ec8:	89 fa                	mov    %edi,%edx
     eca:	8b 45 08             	mov    0x8(%ebp),%eax
     ecd:	e8 36 ff ff ff       	call   e08 <putc>
     ed2:	eb 05                	jmp    ed9 <printf+0x30>
      }
    } else if(state == '%'){
     ed4:	83 fe 25             	cmp    $0x25,%esi
     ed7:	74 25                	je     efe <printf+0x55>
  for(i = 0; fmt[i]; i++){
     ed9:	83 c3 01             	add    $0x1,%ebx
     edc:	8b 45 0c             	mov    0xc(%ebp),%eax
     edf:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
     ee3:	84 c0                	test   %al,%al
     ee5:	0f 84 23 01 00 00    	je     100e <printf+0x165>
    c = fmt[i] & 0xff;
     eeb:	0f be f8             	movsbl %al,%edi
     eee:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
     ef1:	85 f6                	test   %esi,%esi
     ef3:	75 df                	jne    ed4 <printf+0x2b>
      if(c == '%'){
     ef5:	83 f8 25             	cmp    $0x25,%eax
     ef8:	75 ce                	jne    ec8 <printf+0x1f>
        state = '%';
     efa:	89 c6                	mov    %eax,%esi
     efc:	eb db                	jmp    ed9 <printf+0x30>
      if(c == 'd'){
     efe:	83 f8 64             	cmp    $0x64,%eax
     f01:	74 49                	je     f4c <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     f03:	83 f8 78             	cmp    $0x78,%eax
     f06:	0f 94 c1             	sete   %cl
     f09:	83 f8 70             	cmp    $0x70,%eax
     f0c:	0f 94 c2             	sete   %dl
     f0f:	08 d1                	or     %dl,%cl
     f11:	75 63                	jne    f76 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     f13:	83 f8 73             	cmp    $0x73,%eax
     f16:	0f 84 84 00 00 00    	je     fa0 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f1c:	83 f8 63             	cmp    $0x63,%eax
     f1f:	0f 84 b7 00 00 00    	je     fdc <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     f25:	83 f8 25             	cmp    $0x25,%eax
     f28:	0f 84 cc 00 00 00    	je     ffa <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     f2e:	ba 25 00 00 00       	mov    $0x25,%edx
     f33:	8b 45 08             	mov    0x8(%ebp),%eax
     f36:	e8 cd fe ff ff       	call   e08 <putc>
        putc(fd, c);
     f3b:	89 fa                	mov    %edi,%edx
     f3d:	8b 45 08             	mov    0x8(%ebp),%eax
     f40:	e8 c3 fe ff ff       	call   e08 <putc>
      }
      state = 0;
     f45:	be 00 00 00 00       	mov    $0x0,%esi
     f4a:	eb 8d                	jmp    ed9 <printf+0x30>
        printint(fd, *ap, 10, 1);
     f4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
     f4f:	8b 17                	mov    (%edi),%edx
     f51:	83 ec 0c             	sub    $0xc,%esp
     f54:	6a 01                	push   $0x1
     f56:	b9 0a 00 00 00       	mov    $0xa,%ecx
     f5b:	8b 45 08             	mov    0x8(%ebp),%eax
     f5e:	e8 bf fe ff ff       	call   e22 <printint>
        ap++;
     f63:	83 c7 04             	add    $0x4,%edi
     f66:	89 7d e4             	mov    %edi,-0x1c(%ebp)
     f69:	83 c4 10             	add    $0x10,%esp
      state = 0;
     f6c:	be 00 00 00 00       	mov    $0x0,%esi
     f71:	e9 63 ff ff ff       	jmp    ed9 <printf+0x30>
        printint(fd, *ap, 16, 0);
     f76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
     f79:	8b 17                	mov    (%edi),%edx
     f7b:	83 ec 0c             	sub    $0xc,%esp
     f7e:	6a 00                	push   $0x0
     f80:	b9 10 00 00 00       	mov    $0x10,%ecx
     f85:	8b 45 08             	mov    0x8(%ebp),%eax
     f88:	e8 95 fe ff ff       	call   e22 <printint>
        ap++;
     f8d:	83 c7 04             	add    $0x4,%edi
     f90:	89 7d e4             	mov    %edi,-0x1c(%ebp)
     f93:	83 c4 10             	add    $0x10,%esp
      state = 0;
     f96:	be 00 00 00 00       	mov    $0x0,%esi
     f9b:	e9 39 ff ff ff       	jmp    ed9 <printf+0x30>
        s = (char*)*ap;
     fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     fa3:	8b 30                	mov    (%eax),%esi
        ap++;
     fa5:	83 c0 04             	add    $0x4,%eax
     fa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
     fab:	85 f6                	test   %esi,%esi
     fad:	75 28                	jne    fd7 <printf+0x12e>
          s = "(null)";
     faf:	be e8 17 00 00       	mov    $0x17e8,%esi
     fb4:	8b 7d 08             	mov    0x8(%ebp),%edi
     fb7:	eb 0d                	jmp    fc6 <printf+0x11d>
          putc(fd, *s);
     fb9:	0f be d2             	movsbl %dl,%edx
     fbc:	89 f8                	mov    %edi,%eax
     fbe:	e8 45 fe ff ff       	call   e08 <putc>
          s++;
     fc3:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
     fc6:	0f b6 16             	movzbl (%esi),%edx
     fc9:	84 d2                	test   %dl,%dl
     fcb:	75 ec                	jne    fb9 <printf+0x110>
      state = 0;
     fcd:	be 00 00 00 00       	mov    $0x0,%esi
     fd2:	e9 02 ff ff ff       	jmp    ed9 <printf+0x30>
     fd7:	8b 7d 08             	mov    0x8(%ebp),%edi
     fda:	eb ea                	jmp    fc6 <printf+0x11d>
        putc(fd, *ap);
     fdc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
     fdf:	0f be 17             	movsbl (%edi),%edx
     fe2:	8b 45 08             	mov    0x8(%ebp),%eax
     fe5:	e8 1e fe ff ff       	call   e08 <putc>
        ap++;
     fea:	83 c7 04             	add    $0x4,%edi
     fed:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
     ff0:	be 00 00 00 00       	mov    $0x0,%esi
     ff5:	e9 df fe ff ff       	jmp    ed9 <printf+0x30>
        putc(fd, c);
     ffa:	89 fa                	mov    %edi,%edx
     ffc:	8b 45 08             	mov    0x8(%ebp),%eax
     fff:	e8 04 fe ff ff       	call   e08 <putc>
      state = 0;
    1004:	be 00 00 00 00       	mov    $0x0,%esi
    1009:	e9 cb fe ff ff       	jmp    ed9 <printf+0x30>
    }
  }
}
    100e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1011:	5b                   	pop    %ebx
    1012:	5e                   	pop    %esi
    1013:	5f                   	pop    %edi
    1014:	5d                   	pop    %ebp
    1015:	c3                   	ret    

00001016 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1016:	f3 0f 1e fb          	endbr32 
    101a:	55                   	push   %ebp
    101b:	89 e5                	mov    %esp,%ebp
    101d:	57                   	push   %edi
    101e:	56                   	push   %esi
    101f:	53                   	push   %ebx
    1020:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1023:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1026:	a1 f8 1c 00 00       	mov    0x1cf8,%eax
    102b:	eb 02                	jmp    102f <free+0x19>
    102d:	89 d0                	mov    %edx,%eax
    102f:	39 c8                	cmp    %ecx,%eax
    1031:	73 04                	jae    1037 <free+0x21>
    1033:	39 08                	cmp    %ecx,(%eax)
    1035:	77 12                	ja     1049 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1037:	8b 10                	mov    (%eax),%edx
    1039:	39 c2                	cmp    %eax,%edx
    103b:	77 f0                	ja     102d <free+0x17>
    103d:	39 c8                	cmp    %ecx,%eax
    103f:	72 08                	jb     1049 <free+0x33>
    1041:	39 ca                	cmp    %ecx,%edx
    1043:	77 04                	ja     1049 <free+0x33>
    1045:	89 d0                	mov    %edx,%eax
    1047:	eb e6                	jmp    102f <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1049:	8b 73 fc             	mov    -0x4(%ebx),%esi
    104c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    104f:	8b 10                	mov    (%eax),%edx
    1051:	39 d7                	cmp    %edx,%edi
    1053:	74 19                	je     106e <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1055:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1058:	8b 50 04             	mov    0x4(%eax),%edx
    105b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    105e:	39 ce                	cmp    %ecx,%esi
    1060:	74 1b                	je     107d <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1062:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1064:	a3 f8 1c 00 00       	mov    %eax,0x1cf8
}
    1069:	5b                   	pop    %ebx
    106a:	5e                   	pop    %esi
    106b:	5f                   	pop    %edi
    106c:	5d                   	pop    %ebp
    106d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    106e:	03 72 04             	add    0x4(%edx),%esi
    1071:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1074:	8b 10                	mov    (%eax),%edx
    1076:	8b 12                	mov    (%edx),%edx
    1078:	89 53 f8             	mov    %edx,-0x8(%ebx)
    107b:	eb db                	jmp    1058 <free+0x42>
    p->s.size += bp->s.size;
    107d:	03 53 fc             	add    -0x4(%ebx),%edx
    1080:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1083:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1086:	89 10                	mov    %edx,(%eax)
    1088:	eb da                	jmp    1064 <free+0x4e>

0000108a <morecore>:

static Header*
morecore(uint nu)
{
    108a:	55                   	push   %ebp
    108b:	89 e5                	mov    %esp,%ebp
    108d:	53                   	push   %ebx
    108e:	83 ec 04             	sub    $0x4,%esp
    1091:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    1093:	3d ff 0f 00 00       	cmp    $0xfff,%eax
    1098:	77 05                	ja     109f <morecore+0x15>
    nu = 4096;
    109a:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    109f:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    10a6:	83 ec 0c             	sub    $0xc,%esp
    10a9:	50                   	push   %eax
    10aa:	e8 f1 fc ff ff       	call   da0 <sbrk>
  if(p == (char*)-1)
    10af:	83 c4 10             	add    $0x10,%esp
    10b2:	83 f8 ff             	cmp    $0xffffffff,%eax
    10b5:	74 1c                	je     10d3 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    10b7:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    10ba:	83 c0 08             	add    $0x8,%eax
    10bd:	83 ec 0c             	sub    $0xc,%esp
    10c0:	50                   	push   %eax
    10c1:	e8 50 ff ff ff       	call   1016 <free>
  return freep;
    10c6:	a1 f8 1c 00 00       	mov    0x1cf8,%eax
    10cb:	83 c4 10             	add    $0x10,%esp
}
    10ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    10d1:	c9                   	leave  
    10d2:	c3                   	ret    
    return 0;
    10d3:	b8 00 00 00 00       	mov    $0x0,%eax
    10d8:	eb f4                	jmp    10ce <morecore+0x44>

000010da <malloc>:

void*
malloc(uint nbytes)
{
    10da:	f3 0f 1e fb          	endbr32 
    10de:	55                   	push   %ebp
    10df:	89 e5                	mov    %esp,%ebp
    10e1:	53                   	push   %ebx
    10e2:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10e5:	8b 45 08             	mov    0x8(%ebp),%eax
    10e8:	8d 58 07             	lea    0x7(%eax),%ebx
    10eb:	c1 eb 03             	shr    $0x3,%ebx
    10ee:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    10f1:	8b 0d f8 1c 00 00    	mov    0x1cf8,%ecx
    10f7:	85 c9                	test   %ecx,%ecx
    10f9:	74 04                	je     10ff <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10fb:	8b 01                	mov    (%ecx),%eax
    10fd:	eb 4b                	jmp    114a <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
    10ff:	c7 05 f8 1c 00 00 fc 	movl   $0x1cfc,0x1cf8
    1106:	1c 00 00 
    1109:	c7 05 fc 1c 00 00 fc 	movl   $0x1cfc,0x1cfc
    1110:	1c 00 00 
    base.s.size = 0;
    1113:	c7 05 00 1d 00 00 00 	movl   $0x0,0x1d00
    111a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    111d:	b9 fc 1c 00 00       	mov    $0x1cfc,%ecx
    1122:	eb d7                	jmp    10fb <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    1124:	74 1a                	je     1140 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1126:	29 da                	sub    %ebx,%edx
    1128:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    112b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    112e:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    1131:	89 0d f8 1c 00 00    	mov    %ecx,0x1cf8
      return (void*)(p + 1);
    1137:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    113a:	83 c4 04             	add    $0x4,%esp
    113d:	5b                   	pop    %ebx
    113e:	5d                   	pop    %ebp
    113f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1140:	8b 10                	mov    (%eax),%edx
    1142:	89 11                	mov    %edx,(%ecx)
    1144:	eb eb                	jmp    1131 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1146:	89 c1                	mov    %eax,%ecx
    1148:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
    114a:	8b 50 04             	mov    0x4(%eax),%edx
    114d:	39 da                	cmp    %ebx,%edx
    114f:	73 d3                	jae    1124 <malloc+0x4a>
    if(p == freep)
    1151:	39 05 f8 1c 00 00    	cmp    %eax,0x1cf8
    1157:	75 ed                	jne    1146 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
    1159:	89 d8                	mov    %ebx,%eax
    115b:	e8 2a ff ff ff       	call   108a <morecore>
    1160:	85 c0                	test   %eax,%eax
    1162:	75 e2                	jne    1146 <malloc+0x6c>
    1164:	eb d4                	jmp    113a <malloc+0x60>
