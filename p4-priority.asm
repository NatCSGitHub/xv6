
_p4-priority:     file format elf32-i386


Disassembly of section .text:

00000000 <testPromotion>:
// This tests the promotion facility.
//
// It is assumed that setpriority will return the appropriate success/failure codes
void
testPromotion(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
  int pid, prio, newPrio, rc;
  // Test promotion
  printf(1, "\n\nTesting promotion...\n");
   9:	83 ec 08             	sub    $0x8,%esp
   c:	68 50 0a 00 00       	push   $0xa50
  11:	6a 01                	push   $0x1
  13:	e8 7b 07 00 00       	call   793 <printf>
  pid = getpid();
  18:	e8 65 06 00 00       	call   682 <getpid>
  1d:	89 c3                	mov    %eax,%ebx

  rc = setpriority(pid, 0);
  1f:	83 c4 08             	add    $0x8,%esp
  22:	6a 00                	push   $0x0
  24:	50                   	push   %eax
  25:	e8 b8 06 00 00       	call   6e2 <setpriority>

  if (rc != 0) {
  2a:	83 c4 10             	add    $0x10,%esp
  2d:	85 c0                	test   %eax,%eax
  2f:	75 60                	jne    91 <testPromotion+0x91>
    printf(2, "setpriority returned failure code!\n");
    printf(2, "**** TEST FAILED ****\n\n\n");
    return;
  }

  prio = getpriority(pid);
  31:	83 ec 0c             	sub    $0xc,%esp
  34:	53                   	push   %ebx
  35:	e8 b0 06 00 00       	call   6ea <getpriority>
  3a:	89 c6                	mov    %eax,%esi

  sleep(TICKS_TO_PROMOTE + 100);
  3c:	c7 04 24 1c 0c 00 00 	movl   $0xc1c,(%esp)
  43:	e8 4a 06 00 00       	call   692 <sleep>

  newPrio = getpriority(pid);
  48:	89 1c 24             	mov    %ebx,(%esp)
  4b:	e8 9a 06 00 00       	call   6ea <getpriority>

  if (newPrio != prio && newPrio > prio) {
  50:	83 c4 10             	add    $0x10,%esp
  53:	39 c6                	cmp    %eax,%esi
  55:	7d 5d                	jge    b4 <testPromotion+0xb4>
    printf(1, "Promotion has occurred.\n");
  57:	83 ec 08             	sub    $0x8,%esp
  5a:	68 81 0a 00 00       	push   $0xa81
  5f:	6a 01                	push   $0x1
  61:	e8 2d 07 00 00       	call   793 <printf>
    printf(1, "**** TEST PASSES ****\n");
  66:	83 c4 08             	add    $0x8,%esp
  69:	68 9a 0a 00 00       	push   $0xa9a
  6e:	6a 01                	push   $0x1
  70:	e8 1e 07 00 00       	call   793 <printf>
  75:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(2, "Either promotion did not occur or an unexpected change in priority happened.\n");
    printf(2, "**** TEST FAILED ****\n");
  }
  printf(1, "\n\n");
  78:	83 ec 08             	sub    $0x8,%esp
  7b:	68 7e 0a 00 00       	push   $0xa7e
  80:	6a 01                	push   $0x1
  82:	e8 0c 07 00 00       	call   793 <printf>
  87:	83 c4 10             	add    $0x10,%esp
}
  8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8d:	5b                   	pop    %ebx
  8e:	5e                   	pop    %esi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    
    printf(2, "setpriority returned failure code!\n");
  91:	83 ec 08             	sub    $0x8,%esp
  94:	68 68 0b 00 00       	push   $0xb68
  99:	6a 02                	push   $0x2
  9b:	e8 f3 06 00 00       	call   793 <printf>
    printf(2, "**** TEST FAILED ****\n\n\n");
  a0:	83 c4 08             	add    $0x8,%esp
  a3:	68 68 0a 00 00       	push   $0xa68
  a8:	6a 02                	push   $0x2
  aa:	e8 e4 06 00 00       	call   793 <printf>
    return;
  af:	83 c4 10             	add    $0x10,%esp
  b2:	eb d6                	jmp    8a <testPromotion+0x8a>
    printf(2, "Either promotion did not occur or an unexpected change in priority happened.\n");
  b4:	83 ec 08             	sub    $0x8,%esp
  b7:	68 8c 0b 00 00       	push   $0xb8c
  bc:	6a 02                	push   $0x2
  be:	e8 d0 06 00 00       	call   793 <printf>
    printf(2, "**** TEST FAILED ****\n");
  c3:	83 c4 08             	add    $0x8,%esp
  c6:	68 b1 0a 00 00       	push   $0xab1
  cb:	6a 02                	push   $0x2
  cd:	e8 c1 06 00 00       	call   793 <printf>
  d2:	83 c4 10             	add    $0x10,%esp
  d5:	eb a1                	jmp    78 <testPromotion+0x78>

000000d7 <checkPriority>:

// Create a process and change the priority
void
checkPriority(void)
{
  d7:	f3 0f 1e fb          	endbr32 
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	57                   	push   %edi
  df:	56                   	push   %esi
  e0:	53                   	push   %ebx
  e1:	83 ec 14             	sub    $0x14,%esp
  int pid;
  int originalPriority;
  int newPriority;
  int rc;

  printf(1, "Testing that process starts at MAXPRIO\n");
  e4:	68 dc 0b 00 00       	push   $0xbdc
  e9:	6a 01                	push   $0x1
  eb:	e8 a3 06 00 00       	call   793 <printf>

  pid = getpid();
  f0:	e8 8d 05 00 00       	call   682 <getpid>
  f5:	89 c3                	mov    %eax,%ebx
  originalPriority = getpriority(pid);
  f7:	89 04 24             	mov    %eax,(%esp)
  fa:	e8 eb 05 00 00       	call   6ea <getpriority>
  ff:	89 c6                	mov    %eax,%esi

  printf(1, "Priority after program start is %d\n", originalPriority);
 101:	83 c4 0c             	add    $0xc,%esp
 104:	50                   	push   %eax
 105:	68 04 0c 00 00       	push   $0xc04
 10a:	6a 01                	push   $0x1
 10c:	e8 82 06 00 00       	call   793 <printf>
  if (originalPriority != MAXPRIO) {
 111:	83 c4 10             	add    $0x10,%esp
 114:	83 fe 06             	cmp    $0x6,%esi
 117:	0f 84 34 01 00 00    	je     251 <checkPriority+0x17a>
    printf(2, "Process didn't start at MAXPRIO\n");
 11d:	83 ec 08             	sub    $0x8,%esp
 120:	68 28 0c 00 00       	push   $0xc28
 125:	6a 02                	push   $0x2
 127:	e8 67 06 00 00       	call   793 <printf>
    printf(2, "**** TEST FAILED ****\n\n\n");
 12c:	83 c4 08             	add    $0x8,%esp
 12f:	68 68 0a 00 00       	push   $0xa68
 134:	6a 02                	push   $0x2
 136:	e8 58 06 00 00       	call   793 <printf>
 13b:	83 c4 10             	add    $0x10,%esp
  }

  // Test that setting the priority
  //  1. Returns an appropriate code on success
  //  2. Actually changes the priority on success
  rc = setpriority(pid, MAXPRIO);
 13e:	83 ec 08             	sub    $0x8,%esp
 141:	6a 06                	push   $0x6
 143:	53                   	push   %ebx
 144:	e8 99 05 00 00       	call   6e2 <setpriority>
  if (rc != 0) {
 149:	83 c4 10             	add    $0x10,%esp
 14c:	85 c0                	test   %eax,%eax
 14e:	0f 84 14 01 00 00    	je     268 <checkPriority+0x191>
    printf(2, "setpriority(%d, %d) failed!\n", pid, MAXPRIO);
 154:	6a 06                	push   $0x6
 156:	53                   	push   %ebx
 157:	68 c8 0a 00 00       	push   $0xac8
 15c:	6a 02                	push   $0x2
 15e:	e8 30 06 00 00       	call   793 <printf>
    printf(2, "**** TEST FAILED ****\n\n\n");
 163:	83 c4 08             	add    $0x8,%esp
 166:	68 68 0a 00 00       	push   $0xa68
 16b:	6a 02                	push   $0x2
 16d:	e8 21 06 00 00       	call   793 <printf>
 172:	83 c4 10             	add    $0x10,%esp
      printf(2, "**** TEST FAILED ****\n\n\n");
    }
  }

  // Test that the priority cannot be set to a negative number:
  printf(1, "Testing that a priority cannot be set to an out of range value.\n");
 175:	83 ec 08             	sub    $0x8,%esp
 178:	68 78 0c 00 00       	push   $0xc78
 17d:	6a 01                	push   $0x1
 17f:	e8 0f 06 00 00       	call   793 <printf>
  printf(1, "  Testing setting priority to a negative number.\n");
 184:	83 c4 08             	add    $0x8,%esp
 187:	68 bc 0c 00 00       	push   $0xcbc
 18c:	6a 01                	push   $0x1
 18e:	e8 00 06 00 00       	call   793 <printf>
  originalPriority = getpriority(pid);
 193:	89 1c 24             	mov    %ebx,(%esp)
 196:	e8 4f 05 00 00       	call   6ea <getpriority>
 19b:	89 c7                	mov    %eax,%edi
  rc = setpriority(pid, -1);
 19d:	83 c4 08             	add    $0x8,%esp
 1a0:	6a ff                	push   $0xffffffff
 1a2:	53                   	push   %ebx
 1a3:	e8 3a 05 00 00       	call   6e2 <setpriority>
 1a8:	89 c6                	mov    %eax,%esi
  printf(1, "  setPriority(%d, -1) returned %d.\n", pid, rc);
 1aa:	50                   	push   %eax
 1ab:	53                   	push   %ebx
 1ac:	68 f0 0c 00 00       	push   $0xcf0
 1b1:	6a 01                	push   $0x1
 1b3:	e8 db 05 00 00       	call   793 <printf>
  if (rc != 0) {
 1b8:	83 c4 20             	add    $0x20,%esp
 1bb:	85 f6                	test   %esi,%esi
 1bd:	0f 84 f1 00 00 00    	je     2b4 <checkPriority+0x1dd>
    printf(1, "  **** TEST PASSED ****\n\n\n");
 1c3:	83 ec 08             	sub    $0x8,%esp
 1c6:	68 02 0b 00 00       	push   $0xb02
 1cb:	6a 01                	push   $0x1
 1cd:	e8 c1 05 00 00       	call   793 <printf>
 1d2:	83 c4 10             	add    $0x10,%esp
      printf(2, "  **** TEST FAILED ****\n\n");
    }
  }

  // Test that the priority on a bogus PID cannot be set
  printf(1, "  Testing that a priority cannot be set on a non-existent PID.\n");
 1d5:	83 ec 08             	sub    $0x8,%esp
 1d8:	68 ac 0d 00 00       	push   $0xdac
 1dd:	6a 01                	push   $0x1
 1df:	e8 af 05 00 00       	call   793 <printf>
  rc = setpriority(32767, MAXPRIO);
 1e4:	83 c4 08             	add    $0x8,%esp
 1e7:	6a 06                	push   $0x6
 1e9:	68 ff 7f 00 00       	push   $0x7fff
 1ee:	e8 ef 04 00 00       	call   6e2 <setpriority>
 1f3:	89 c3                	mov    %eax,%ebx
  if (rc != 0) {
 1f5:	83 c4 10             	add    $0x10,%esp
 1f8:	85 c0                	test   %eax,%eax
 1fa:	0f 84 1b 01 00 00    	je     31b <checkPriority+0x244>
    printf(1, "  **** TEST PASSED ****\n\n\n");
 200:	83 ec 08             	sub    $0x8,%esp
 203:	68 02 0b 00 00       	push   $0xb02
 208:	6a 01                	push   $0x1
 20a:	e8 84 05 00 00       	call   793 <printf>
 20f:	83 c4 10             	add    $0x10,%esp
    printf(2, "  **** TEST FAILED ****\n\n");
  }

  // Test the priority of a known PID:
  pid = 1; // init
  int prio = getpriority(pid);
 212:	83 ec 0c             	sub    $0xc,%esp
 215:	6a 01                	push   $0x1
 217:	e8 ce 04 00 00       	call   6ea <getpriority>
  printf(1, "Priority for pid %d is %d\n", pid, prio);
 21c:	50                   	push   %eax
 21d:	6a 01                	push   $0x1
 21f:	68 37 0b 00 00       	push   $0xb37
 224:	6a 01                	push   $0x1
 226:	e8 68 05 00 00       	call   793 <printf>
  printf(1, "Press C-p to verify.\n");
 22b:	83 c4 18             	add    $0x18,%esp
 22e:	68 52 0b 00 00       	push   $0xb52
 233:	6a 01                	push   $0x1
 235:	e8 59 05 00 00       	call   793 <printf>
  sleep(5 * TPS);
 23a:	c7 04 24 88 13 00 00 	movl   $0x1388,(%esp)
 241:	e8 4c 04 00 00       	call   692 <sleep>
}
 246:	83 c4 10             	add    $0x10,%esp
 249:	8d 65 f4             	lea    -0xc(%ebp),%esp
 24c:	5b                   	pop    %ebx
 24d:	5e                   	pop    %esi
 24e:	5f                   	pop    %edi
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    
    printf(1, "**** TEST PASSED ****\n\n\n");
 251:	83 ec 08             	sub    $0x8,%esp
 254:	68 04 0b 00 00       	push   $0xb04
 259:	6a 01                	push   $0x1
 25b:	e8 33 05 00 00       	call   793 <printf>
 260:	83 c4 10             	add    $0x10,%esp
 263:	e9 d6 fe ff ff       	jmp    13e <checkPriority+0x67>
    newPriority = getpriority(pid);
 268:	83 ec 0c             	sub    $0xc,%esp
 26b:	53                   	push   %ebx
 26c:	e8 79 04 00 00       	call   6ea <getpriority>
 271:	89 c6                	mov    %eax,%esi
    if (newPriority != MAXPRIO) {
 273:	83 c4 10             	add    $0x10,%esp
 276:	83 f8 06             	cmp    $0x6,%eax
 279:	0f 84 f6 fe ff ff    	je     175 <checkPriority+0x9e>
      printf(2, "setpriority(%d, %d) failed.\n", pid, MAXPRIO);
 27f:	6a 06                	push   $0x6
 281:	53                   	push   %ebx
 282:	68 e5 0a 00 00       	push   $0xae5
 287:	6a 02                	push   $0x2
 289:	e8 05 05 00 00       	call   793 <printf>
      printf(2, "New priority is %d, but it should be %d.\n", newPriority, MAXPRIO);
 28e:	6a 06                	push   $0x6
 290:	56                   	push   %esi
 291:	68 4c 0c 00 00       	push   $0xc4c
 296:	6a 02                	push   $0x2
 298:	e8 f6 04 00 00       	call   793 <printf>
      printf(2, "**** TEST FAILED ****\n\n\n");
 29d:	83 c4 18             	add    $0x18,%esp
 2a0:	68 68 0a 00 00       	push   $0xa68
 2a5:	6a 02                	push   $0x2
 2a7:	e8 e7 04 00 00       	call   793 <printf>
 2ac:	83 c4 10             	add    $0x10,%esp
 2af:	e9 c1 fe ff ff       	jmp    175 <checkPriority+0x9e>
    printf(2, "  setPriority should have indicated failed.\n");
 2b4:	83 ec 08             	sub    $0x8,%esp
 2b7:	68 14 0d 00 00       	push   $0xd14
 2bc:	6a 02                	push   $0x2
 2be:	e8 d0 04 00 00       	call   793 <printf>
    printf(2, "  **** TEST FAILED ****\n\n");
 2c3:	83 c4 08             	add    $0x8,%esp
 2c6:	68 1d 0b 00 00       	push   $0xb1d
 2cb:	6a 02                	push   $0x2
 2cd:	e8 c1 04 00 00       	call   793 <printf>
    newPriority = getpriority(pid);
 2d2:	89 1c 24             	mov    %ebx,(%esp)
 2d5:	e8 10 04 00 00       	call   6ea <getpriority>
 2da:	89 c3                	mov    %eax,%ebx
    if (newPriority != originalPriority) {
 2dc:	83 c4 10             	add    $0x10,%esp
 2df:	39 c7                	cmp    %eax,%edi
 2e1:	0f 84 ee fe ff ff    	je     1d5 <checkPriority+0xfe>
      printf(2, "  setPriority failed but the priority was changed.\n");
 2e7:	83 ec 08             	sub    $0x8,%esp
 2ea:	68 44 0d 00 00       	push   $0xd44
 2ef:	6a 02                	push   $0x2
 2f1:	e8 9d 04 00 00       	call   793 <printf>
      printf(2, "  Original priority was %d; new priority is %d.\n", originalPriority, newPriority);
 2f6:	53                   	push   %ebx
 2f7:	57                   	push   %edi
 2f8:	68 78 0d 00 00       	push   $0xd78
 2fd:	6a 02                	push   $0x2
 2ff:	e8 8f 04 00 00       	call   793 <printf>
      printf(2, "  **** TEST FAILED ****\n\n");
 304:	83 c4 18             	add    $0x18,%esp
 307:	68 1d 0b 00 00       	push   $0xb1d
 30c:	6a 02                	push   $0x2
 30e:	e8 80 04 00 00       	call   793 <printf>
 313:	83 c4 10             	add    $0x10,%esp
 316:	e9 ba fe ff ff       	jmp    1d5 <checkPriority+0xfe>
    printf(2, "  Attempted to set the priority of PID 32767 to %d.\n", MAXPRIO);
 31b:	83 ec 04             	sub    $0x4,%esp
 31e:	6a 06                	push   $0x6
 320:	68 ec 0d 00 00       	push   $0xdec
 325:	6a 02                	push   $0x2
 327:	e8 67 04 00 00       	call   793 <printf>
    printf(2, "  This should have returned a non-zero value but returned %d.\n", rc);
 32c:	83 c4 0c             	add    $0xc,%esp
 32f:	53                   	push   %ebx
 330:	68 24 0e 00 00       	push   $0xe24
 335:	6a 02                	push   $0x2
 337:	e8 57 04 00 00       	call   793 <printf>
    printf(2, "  **** TEST FAILED ****\n\n");
 33c:	83 c4 08             	add    $0x8,%esp
 33f:	68 1d 0b 00 00       	push   $0xb1d
 344:	6a 02                	push   $0x2
 346:	e8 48 04 00 00       	call   793 <printf>
 34b:	83 c4 10             	add    $0x10,%esp
 34e:	e9 bf fe ff ff       	jmp    212 <checkPriority+0x13b>

00000353 <main>:

int
main(int argc, char* argv[])
{
 353:	f3 0f 1e fb          	endbr32 
 357:	55                   	push   %ebp
 358:	89 e5                	mov    %esp,%ebp
 35a:	83 e4 f0             	and    $0xfffffff0,%esp
  if (MAXPRIO == 0) {
    printf(1, "MAXPRIO is 0. Change MAXPRIO and try again\n");
    exit();
  }

  checkPriority();
 35d:	e8 75 fd ff ff       	call   d7 <checkPriority>

  testPromotion();
 362:	e8 99 fc ff ff       	call   0 <testPromotion>
  exit();
 367:	e8 96 02 00 00       	call   602 <exit>

0000036c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 36c:	f3 0f 1e fb          	endbr32 
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	56                   	push   %esi
 374:	53                   	push   %ebx
 375:	8b 75 08             	mov    0x8(%ebp),%esi
 378:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 37b:	89 f0                	mov    %esi,%eax
 37d:	89 d1                	mov    %edx,%ecx
 37f:	83 c2 01             	add    $0x1,%edx
 382:	89 c3                	mov    %eax,%ebx
 384:	83 c0 01             	add    $0x1,%eax
 387:	0f b6 09             	movzbl (%ecx),%ecx
 38a:	88 0b                	mov    %cl,(%ebx)
 38c:	84 c9                	test   %cl,%cl
 38e:	75 ed                	jne    37d <strcpy+0x11>
    ;
  return os;
}
 390:	89 f0                	mov    %esi,%eax
 392:	5b                   	pop    %ebx
 393:	5e                   	pop    %esi
 394:	5d                   	pop    %ebp
 395:	c3                   	ret    

00000396 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 396:	f3 0f 1e fb          	endbr32 
 39a:	55                   	push   %ebp
 39b:	89 e5                	mov    %esp,%ebp
 39d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 3a3:	0f b6 01             	movzbl (%ecx),%eax
 3a6:	84 c0                	test   %al,%al
 3a8:	74 0c                	je     3b6 <strcmp+0x20>
 3aa:	3a 02                	cmp    (%edx),%al
 3ac:	75 08                	jne    3b6 <strcmp+0x20>
    p++, q++;
 3ae:	83 c1 01             	add    $0x1,%ecx
 3b1:	83 c2 01             	add    $0x1,%edx
 3b4:	eb ed                	jmp    3a3 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 3b6:	0f b6 c0             	movzbl %al,%eax
 3b9:	0f b6 12             	movzbl (%edx),%edx
 3bc:	29 d0                	sub    %edx,%eax
}
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret    

000003c0 <strlen>:

uint
strlen(char *s)
{
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3ca:	b8 00 00 00 00       	mov    $0x0,%eax
 3cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 3d3:	74 05                	je     3da <strlen+0x1a>
 3d5:	83 c0 01             	add    $0x1,%eax
 3d8:	eb f5                	jmp    3cf <strlen+0xf>
    ;
  return n;
}
 3da:	5d                   	pop    %ebp
 3db:	c3                   	ret    

000003dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 3dc:	f3 0f 1e fb          	endbr32 
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3e7:	89 d7                	mov    %edx,%edi
 3e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ef:	fc                   	cld    
 3f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3f2:	89 d0                	mov    %edx,%eax
 3f4:	5f                   	pop    %edi
 3f5:	5d                   	pop    %ebp
 3f6:	c3                   	ret    

000003f7 <strchr>:

char*
strchr(const char *s, char c)
{
 3f7:	f3 0f 1e fb          	endbr32 
 3fb:	55                   	push   %ebp
 3fc:	89 e5                	mov    %esp,%ebp
 3fe:	8b 45 08             	mov    0x8(%ebp),%eax
 401:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 405:	0f b6 10             	movzbl (%eax),%edx
 408:	84 d2                	test   %dl,%dl
 40a:	74 09                	je     415 <strchr+0x1e>
    if(*s == c)
 40c:	38 ca                	cmp    %cl,%dl
 40e:	74 0a                	je     41a <strchr+0x23>
  for(; *s; s++)
 410:	83 c0 01             	add    $0x1,%eax
 413:	eb f0                	jmp    405 <strchr+0xe>
      return (char*)s;
  return 0;
 415:	b8 00 00 00 00       	mov    $0x0,%eax
}
 41a:	5d                   	pop    %ebp
 41b:	c3                   	ret    

0000041c <gets>:

char*
gets(char *buf, int max)
{
 41c:	f3 0f 1e fb          	endbr32 
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
 426:	83 ec 1c             	sub    $0x1c,%esp
 429:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 42c:	bb 00 00 00 00       	mov    $0x0,%ebx
 431:	89 de                	mov    %ebx,%esi
 433:	83 c3 01             	add    $0x1,%ebx
 436:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 439:	7d 2e                	jge    469 <gets+0x4d>
    cc = read(0, &c, 1);
 43b:	83 ec 04             	sub    $0x4,%esp
 43e:	6a 01                	push   $0x1
 440:	8d 45 e7             	lea    -0x19(%ebp),%eax
 443:	50                   	push   %eax
 444:	6a 00                	push   $0x0
 446:	e8 cf 01 00 00       	call   61a <read>
    if(cc < 1)
 44b:	83 c4 10             	add    $0x10,%esp
 44e:	85 c0                	test   %eax,%eax
 450:	7e 17                	jle    469 <gets+0x4d>
      break;
    buf[i++] = c;
 452:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 456:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 459:	3c 0a                	cmp    $0xa,%al
 45b:	0f 94 c2             	sete   %dl
 45e:	3c 0d                	cmp    $0xd,%al
 460:	0f 94 c0             	sete   %al
 463:	08 c2                	or     %al,%dl
 465:	74 ca                	je     431 <gets+0x15>
    buf[i++] = c;
 467:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 469:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 46d:	89 f8                	mov    %edi,%eax
 46f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 472:	5b                   	pop    %ebx
 473:	5e                   	pop    %esi
 474:	5f                   	pop    %edi
 475:	5d                   	pop    %ebp
 476:	c3                   	ret    

00000477 <stat>:

int
stat(char *n, struct stat *st)
{
 477:	f3 0f 1e fb          	endbr32 
 47b:	55                   	push   %ebp
 47c:	89 e5                	mov    %esp,%ebp
 47e:	56                   	push   %esi
 47f:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 480:	83 ec 08             	sub    $0x8,%esp
 483:	6a 00                	push   $0x0
 485:	ff 75 08             	pushl  0x8(%ebp)
 488:	e8 b5 01 00 00       	call   642 <open>
  if(fd < 0)
 48d:	83 c4 10             	add    $0x10,%esp
 490:	85 c0                	test   %eax,%eax
 492:	78 24                	js     4b8 <stat+0x41>
 494:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 496:	83 ec 08             	sub    $0x8,%esp
 499:	ff 75 0c             	pushl  0xc(%ebp)
 49c:	50                   	push   %eax
 49d:	e8 b8 01 00 00       	call   65a <fstat>
 4a2:	89 c6                	mov    %eax,%esi
  close(fd);
 4a4:	89 1c 24             	mov    %ebx,(%esp)
 4a7:	e8 7e 01 00 00       	call   62a <close>
  return r;
 4ac:	83 c4 10             	add    $0x10,%esp
}
 4af:	89 f0                	mov    %esi,%eax
 4b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4b4:	5b                   	pop    %ebx
 4b5:	5e                   	pop    %esi
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    
    return -1;
 4b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4bd:	eb f0                	jmp    4af <stat+0x38>

000004bf <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 4bf:	f3 0f 1e fb          	endbr32 
 4c3:	55                   	push   %ebp
 4c4:	89 e5                	mov    %esp,%ebp
 4c6:	57                   	push   %edi
 4c7:	56                   	push   %esi
 4c8:	53                   	push   %ebx
 4c9:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 4cc:	0f b6 02             	movzbl (%edx),%eax
 4cf:	3c 20                	cmp    $0x20,%al
 4d1:	75 05                	jne    4d8 <atoi+0x19>
 4d3:	83 c2 01             	add    $0x1,%edx
 4d6:	eb f4                	jmp    4cc <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 4d8:	3c 2d                	cmp    $0x2d,%al
 4da:	74 1d                	je     4f9 <atoi+0x3a>
 4dc:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 4e1:	3c 2b                	cmp    $0x2b,%al
 4e3:	0f 94 c1             	sete   %cl
 4e6:	3c 2d                	cmp    $0x2d,%al
 4e8:	0f 94 c0             	sete   %al
 4eb:	08 c1                	or     %al,%cl
 4ed:	74 03                	je     4f2 <atoi+0x33>
    s++;
 4ef:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 4f2:	b8 00 00 00 00       	mov    $0x0,%eax
 4f7:	eb 17                	jmp    510 <atoi+0x51>
 4f9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 4fe:	eb e1                	jmp    4e1 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 500:	8d 34 80             	lea    (%eax,%eax,4),%esi
 503:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 506:	83 c2 01             	add    $0x1,%edx
 509:	0f be c9             	movsbl %cl,%ecx
 50c:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 510:	0f b6 0a             	movzbl (%edx),%ecx
 513:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 516:	80 fb 09             	cmp    $0x9,%bl
 519:	76 e5                	jbe    500 <atoi+0x41>
  return sign*n;
 51b:	0f af c7             	imul   %edi,%eax
}
 51e:	5b                   	pop    %ebx
 51f:	5e                   	pop    %esi
 520:	5f                   	pop    %edi
 521:	5d                   	pop    %ebp
 522:	c3                   	ret    

00000523 <atoo>:

int
atoo(const char *s)
{
 523:	f3 0f 1e fb          	endbr32 
 527:	55                   	push   %ebp
 528:	89 e5                	mov    %esp,%ebp
 52a:	57                   	push   %edi
 52b:	56                   	push   %esi
 52c:	53                   	push   %ebx
 52d:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 530:	0f b6 0a             	movzbl (%edx),%ecx
 533:	80 f9 20             	cmp    $0x20,%cl
 536:	75 05                	jne    53d <atoo+0x1a>
 538:	83 c2 01             	add    $0x1,%edx
 53b:	eb f3                	jmp    530 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 53d:	80 f9 2d             	cmp    $0x2d,%cl
 540:	74 23                	je     565 <atoo+0x42>
 542:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 547:	80 f9 2b             	cmp    $0x2b,%cl
 54a:	0f 94 c0             	sete   %al
 54d:	89 c6                	mov    %eax,%esi
 54f:	80 f9 2d             	cmp    $0x2d,%cl
 552:	0f 94 c0             	sete   %al
 555:	89 f3                	mov    %esi,%ebx
 557:	08 c3                	or     %al,%bl
 559:	74 03                	je     55e <atoo+0x3b>
    s++;
 55b:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 55e:	b8 00 00 00 00       	mov    $0x0,%eax
 563:	eb 11                	jmp    576 <atoo+0x53>
 565:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 56a:	eb db                	jmp    547 <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 56c:	83 c2 01             	add    $0x1,%edx
 56f:	0f be c9             	movsbl %cl,%ecx
 572:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 576:	0f b6 0a             	movzbl (%edx),%ecx
 579:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 57c:	80 fb 07             	cmp    $0x7,%bl
 57f:	76 eb                	jbe    56c <atoo+0x49>
  return sign*n;
 581:	0f af c7             	imul   %edi,%eax
}
 584:	5b                   	pop    %ebx
 585:	5e                   	pop    %esi
 586:	5f                   	pop    %edi
 587:	5d                   	pop    %ebp
 588:	c3                   	ret    

00000589 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 589:	f3 0f 1e fb          	endbr32 
 58d:	55                   	push   %ebp
 58e:	89 e5                	mov    %esp,%ebp
 590:	53                   	push   %ebx
 591:	8b 55 08             	mov    0x8(%ebp),%edx
 594:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 597:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 59a:	eb 09                	jmp    5a5 <strncmp+0x1c>
      n--, p++, q++;
 59c:	83 e8 01             	sub    $0x1,%eax
 59f:	83 c2 01             	add    $0x1,%edx
 5a2:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 5a5:	85 c0                	test   %eax,%eax
 5a7:	74 0b                	je     5b4 <strncmp+0x2b>
 5a9:	0f b6 1a             	movzbl (%edx),%ebx
 5ac:	84 db                	test   %bl,%bl
 5ae:	74 04                	je     5b4 <strncmp+0x2b>
 5b0:	3a 19                	cmp    (%ecx),%bl
 5b2:	74 e8                	je     59c <strncmp+0x13>
    if(n == 0)
 5b4:	85 c0                	test   %eax,%eax
 5b6:	74 0b                	je     5c3 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 5b8:	0f b6 02             	movzbl (%edx),%eax
 5bb:	0f b6 11             	movzbl (%ecx),%edx
 5be:	29 d0                	sub    %edx,%eax
}
 5c0:	5b                   	pop    %ebx
 5c1:	5d                   	pop    %ebp
 5c2:	c3                   	ret    
      return 0;
 5c3:	b8 00 00 00 00       	mov    $0x0,%eax
 5c8:	eb f6                	jmp    5c0 <strncmp+0x37>

000005ca <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 5ca:	f3 0f 1e fb          	endbr32 
 5ce:	55                   	push   %ebp
 5cf:	89 e5                	mov    %esp,%ebp
 5d1:	56                   	push   %esi
 5d2:	53                   	push   %ebx
 5d3:	8b 75 08             	mov    0x8(%ebp),%esi
 5d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 5d9:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 5dc:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 5de:	8d 58 ff             	lea    -0x1(%eax),%ebx
 5e1:	85 c0                	test   %eax,%eax
 5e3:	7e 0f                	jle    5f4 <memmove+0x2a>
    *dst++ = *src++;
 5e5:	0f b6 01             	movzbl (%ecx),%eax
 5e8:	88 02                	mov    %al,(%edx)
 5ea:	8d 49 01             	lea    0x1(%ecx),%ecx
 5ed:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 5f0:	89 d8                	mov    %ebx,%eax
 5f2:	eb ea                	jmp    5de <memmove+0x14>
  return vdst;
}
 5f4:	89 f0                	mov    %esi,%eax
 5f6:	5b                   	pop    %ebx
 5f7:	5e                   	pop    %esi
 5f8:	5d                   	pop    %ebp
 5f9:	c3                   	ret    

000005fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5fa:	b8 01 00 00 00       	mov    $0x1,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <exit>:
SYSCALL(exit)
 602:	b8 02 00 00 00       	mov    $0x2,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <wait>:
SYSCALL(wait)
 60a:	b8 03 00 00 00       	mov    $0x3,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <pipe>:
SYSCALL(pipe)
 612:	b8 04 00 00 00       	mov    $0x4,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <read>:
SYSCALL(read)
 61a:	b8 05 00 00 00       	mov    $0x5,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <write>:
SYSCALL(write)
 622:	b8 10 00 00 00       	mov    $0x10,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <close>:
SYSCALL(close)
 62a:	b8 15 00 00 00       	mov    $0x15,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <kill>:
SYSCALL(kill)
 632:	b8 06 00 00 00       	mov    $0x6,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <exec>:
SYSCALL(exec)
 63a:	b8 07 00 00 00       	mov    $0x7,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <open>:
SYSCALL(open)
 642:	b8 0f 00 00 00       	mov    $0xf,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <mknod>:
SYSCALL(mknod)
 64a:	b8 11 00 00 00       	mov    $0x11,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <unlink>:
SYSCALL(unlink)
 652:	b8 12 00 00 00       	mov    $0x12,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <fstat>:
SYSCALL(fstat)
 65a:	b8 08 00 00 00       	mov    $0x8,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <link>:
SYSCALL(link)
 662:	b8 13 00 00 00       	mov    $0x13,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <mkdir>:
SYSCALL(mkdir)
 66a:	b8 14 00 00 00       	mov    $0x14,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <chdir>:
SYSCALL(chdir)
 672:	b8 09 00 00 00       	mov    $0x9,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <dup>:
SYSCALL(dup)
 67a:	b8 0a 00 00 00       	mov    $0xa,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <getpid>:
SYSCALL(getpid)
 682:	b8 0b 00 00 00       	mov    $0xb,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <sbrk>:
SYSCALL(sbrk)
 68a:	b8 0c 00 00 00       	mov    $0xc,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <sleep>:
SYSCALL(sleep)
 692:	b8 0d 00 00 00       	mov    $0xd,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <uptime>:
SYSCALL(uptime)
 69a:	b8 0e 00 00 00       	mov    $0xe,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <halt>:
SYSCALL(halt)
 6a2:	b8 16 00 00 00       	mov    $0x16,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <date>:
SYSCALL(date)
 6aa:	b8 17 00 00 00       	mov    $0x17,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <getuid>:
SYSCALL(getuid)
 6b2:	b8 18 00 00 00       	mov    $0x18,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <getgid>:
SYSCALL(getgid)
 6ba:	b8 19 00 00 00       	mov    $0x19,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <getppid>:
SYSCALL(getppid)
 6c2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    

000006ca <setuid>:
SYSCALL(setuid)
 6ca:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6cf:	cd 40                	int    $0x40
 6d1:	c3                   	ret    

000006d2 <setgid>:
SYSCALL(setgid)
 6d2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6d7:	cd 40                	int    $0x40
 6d9:	c3                   	ret    

000006da <getprocs>:
SYSCALL(getprocs)
 6da:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6df:	cd 40                	int    $0x40
 6e1:	c3                   	ret    

000006e2 <setpriority>:
SYSCALL(setpriority)
 6e2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6e7:	cd 40                	int    $0x40
 6e9:	c3                   	ret    

000006ea <getpriority>:
SYSCALL(getpriority)
 6ea:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6ef:	cd 40                	int    $0x40
 6f1:	c3                   	ret    

000006f2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6f2:	55                   	push   %ebp
 6f3:	89 e5                	mov    %esp,%ebp
 6f5:	83 ec 1c             	sub    $0x1c,%esp
 6f8:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 6fb:	6a 01                	push   $0x1
 6fd:	8d 55 f4             	lea    -0xc(%ebp),%edx
 700:	52                   	push   %edx
 701:	50                   	push   %eax
 702:	e8 1b ff ff ff       	call   622 <write>
}
 707:	83 c4 10             	add    $0x10,%esp
 70a:	c9                   	leave  
 70b:	c3                   	ret    

0000070c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 70c:	55                   	push   %ebp
 70d:	89 e5                	mov    %esp,%ebp
 70f:	57                   	push   %edi
 710:	56                   	push   %esi
 711:	53                   	push   %ebx
 712:	83 ec 2c             	sub    $0x2c,%esp
 715:	89 45 d0             	mov    %eax,-0x30(%ebp)
 718:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 71a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 71e:	0f 95 c2             	setne  %dl
 721:	89 f0                	mov    %esi,%eax
 723:	c1 e8 1f             	shr    $0x1f,%eax
 726:	84 c2                	test   %al,%dl
 728:	74 42                	je     76c <printint+0x60>
    neg = 1;
    x = -xx;
 72a:	f7 de                	neg    %esi
    neg = 1;
 72c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 733:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 738:	89 f0                	mov    %esi,%eax
 73a:	ba 00 00 00 00       	mov    $0x0,%edx
 73f:	f7 f1                	div    %ecx
 741:	89 df                	mov    %ebx,%edi
 743:	83 c3 01             	add    $0x1,%ebx
 746:	0f b6 92 6c 0e 00 00 	movzbl 0xe6c(%edx),%edx
 74d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 751:	89 f2                	mov    %esi,%edx
 753:	89 c6                	mov    %eax,%esi
 755:	39 d1                	cmp    %edx,%ecx
 757:	76 df                	jbe    738 <printint+0x2c>
  if(neg)
 759:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 75d:	74 2f                	je     78e <printint+0x82>
    buf[i++] = '-';
 75f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 764:	8d 5f 02             	lea    0x2(%edi),%ebx
 767:	8b 75 d0             	mov    -0x30(%ebp),%esi
 76a:	eb 15                	jmp    781 <printint+0x75>
  neg = 0;
 76c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 773:	eb be                	jmp    733 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 775:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 77a:	89 f0                	mov    %esi,%eax
 77c:	e8 71 ff ff ff       	call   6f2 <putc>
  while(--i >= 0)
 781:	83 eb 01             	sub    $0x1,%ebx
 784:	79 ef                	jns    775 <printint+0x69>
}
 786:	83 c4 2c             	add    $0x2c,%esp
 789:	5b                   	pop    %ebx
 78a:	5e                   	pop    %esi
 78b:	5f                   	pop    %edi
 78c:	5d                   	pop    %ebp
 78d:	c3                   	ret    
 78e:	8b 75 d0             	mov    -0x30(%ebp),%esi
 791:	eb ee                	jmp    781 <printint+0x75>

00000793 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 793:	f3 0f 1e fb          	endbr32 
 797:	55                   	push   %ebp
 798:	89 e5                	mov    %esp,%ebp
 79a:	57                   	push   %edi
 79b:	56                   	push   %esi
 79c:	53                   	push   %ebx
 79d:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 7a0:	8d 45 10             	lea    0x10(%ebp),%eax
 7a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 7a6:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 7ab:	bb 00 00 00 00       	mov    $0x0,%ebx
 7b0:	eb 14                	jmp    7c6 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 7b2:	89 fa                	mov    %edi,%edx
 7b4:	8b 45 08             	mov    0x8(%ebp),%eax
 7b7:	e8 36 ff ff ff       	call   6f2 <putc>
 7bc:	eb 05                	jmp    7c3 <printf+0x30>
      }
    } else if(state == '%'){
 7be:	83 fe 25             	cmp    $0x25,%esi
 7c1:	74 25                	je     7e8 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 7c3:	83 c3 01             	add    $0x1,%ebx
 7c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 7c9:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 7cd:	84 c0                	test   %al,%al
 7cf:	0f 84 23 01 00 00    	je     8f8 <printf+0x165>
    c = fmt[i] & 0xff;
 7d5:	0f be f8             	movsbl %al,%edi
 7d8:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 7db:	85 f6                	test   %esi,%esi
 7dd:	75 df                	jne    7be <printf+0x2b>
      if(c == '%'){
 7df:	83 f8 25             	cmp    $0x25,%eax
 7e2:	75 ce                	jne    7b2 <printf+0x1f>
        state = '%';
 7e4:	89 c6                	mov    %eax,%esi
 7e6:	eb db                	jmp    7c3 <printf+0x30>
      if(c == 'd'){
 7e8:	83 f8 64             	cmp    $0x64,%eax
 7eb:	74 49                	je     836 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7ed:	83 f8 78             	cmp    $0x78,%eax
 7f0:	0f 94 c1             	sete   %cl
 7f3:	83 f8 70             	cmp    $0x70,%eax
 7f6:	0f 94 c2             	sete   %dl
 7f9:	08 d1                	or     %dl,%cl
 7fb:	75 63                	jne    860 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7fd:	83 f8 73             	cmp    $0x73,%eax
 800:	0f 84 84 00 00 00    	je     88a <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 806:	83 f8 63             	cmp    $0x63,%eax
 809:	0f 84 b7 00 00 00    	je     8c6 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 80f:	83 f8 25             	cmp    $0x25,%eax
 812:	0f 84 cc 00 00 00    	je     8e4 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 818:	ba 25 00 00 00       	mov    $0x25,%edx
 81d:	8b 45 08             	mov    0x8(%ebp),%eax
 820:	e8 cd fe ff ff       	call   6f2 <putc>
        putc(fd, c);
 825:	89 fa                	mov    %edi,%edx
 827:	8b 45 08             	mov    0x8(%ebp),%eax
 82a:	e8 c3 fe ff ff       	call   6f2 <putc>
      }
      state = 0;
 82f:	be 00 00 00 00       	mov    $0x0,%esi
 834:	eb 8d                	jmp    7c3 <printf+0x30>
        printint(fd, *ap, 10, 1);
 836:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 839:	8b 17                	mov    (%edi),%edx
 83b:	83 ec 0c             	sub    $0xc,%esp
 83e:	6a 01                	push   $0x1
 840:	b9 0a 00 00 00       	mov    $0xa,%ecx
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	e8 bf fe ff ff       	call   70c <printint>
        ap++;
 84d:	83 c7 04             	add    $0x4,%edi
 850:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 853:	83 c4 10             	add    $0x10,%esp
      state = 0;
 856:	be 00 00 00 00       	mov    $0x0,%esi
 85b:	e9 63 ff ff ff       	jmp    7c3 <printf+0x30>
        printint(fd, *ap, 16, 0);
 860:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 863:	8b 17                	mov    (%edi),%edx
 865:	83 ec 0c             	sub    $0xc,%esp
 868:	6a 00                	push   $0x0
 86a:	b9 10 00 00 00       	mov    $0x10,%ecx
 86f:	8b 45 08             	mov    0x8(%ebp),%eax
 872:	e8 95 fe ff ff       	call   70c <printint>
        ap++;
 877:	83 c7 04             	add    $0x4,%edi
 87a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 87d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 880:	be 00 00 00 00       	mov    $0x0,%esi
 885:	e9 39 ff ff ff       	jmp    7c3 <printf+0x30>
        s = (char*)*ap;
 88a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 88d:	8b 30                	mov    (%eax),%esi
        ap++;
 88f:	83 c0 04             	add    $0x4,%eax
 892:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 895:	85 f6                	test   %esi,%esi
 897:	75 28                	jne    8c1 <printf+0x12e>
          s = "(null)";
 899:	be 63 0e 00 00       	mov    $0xe63,%esi
 89e:	8b 7d 08             	mov    0x8(%ebp),%edi
 8a1:	eb 0d                	jmp    8b0 <printf+0x11d>
          putc(fd, *s);
 8a3:	0f be d2             	movsbl %dl,%edx
 8a6:	89 f8                	mov    %edi,%eax
 8a8:	e8 45 fe ff ff       	call   6f2 <putc>
          s++;
 8ad:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 8b0:	0f b6 16             	movzbl (%esi),%edx
 8b3:	84 d2                	test   %dl,%dl
 8b5:	75 ec                	jne    8a3 <printf+0x110>
      state = 0;
 8b7:	be 00 00 00 00       	mov    $0x0,%esi
 8bc:	e9 02 ff ff ff       	jmp    7c3 <printf+0x30>
 8c1:	8b 7d 08             	mov    0x8(%ebp),%edi
 8c4:	eb ea                	jmp    8b0 <printf+0x11d>
        putc(fd, *ap);
 8c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 8c9:	0f be 17             	movsbl (%edi),%edx
 8cc:	8b 45 08             	mov    0x8(%ebp),%eax
 8cf:	e8 1e fe ff ff       	call   6f2 <putc>
        ap++;
 8d4:	83 c7 04             	add    $0x4,%edi
 8d7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 8da:	be 00 00 00 00       	mov    $0x0,%esi
 8df:	e9 df fe ff ff       	jmp    7c3 <printf+0x30>
        putc(fd, c);
 8e4:	89 fa                	mov    %edi,%edx
 8e6:	8b 45 08             	mov    0x8(%ebp),%eax
 8e9:	e8 04 fe ff ff       	call   6f2 <putc>
      state = 0;
 8ee:	be 00 00 00 00       	mov    $0x0,%esi
 8f3:	e9 cb fe ff ff       	jmp    7c3 <printf+0x30>
    }
  }
}
 8f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8fb:	5b                   	pop    %ebx
 8fc:	5e                   	pop    %esi
 8fd:	5f                   	pop    %edi
 8fe:	5d                   	pop    %ebp
 8ff:	c3                   	ret    

00000900 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 900:	f3 0f 1e fb          	endbr32 
 904:	55                   	push   %ebp
 905:	89 e5                	mov    %esp,%ebp
 907:	57                   	push   %edi
 908:	56                   	push   %esi
 909:	53                   	push   %ebx
 90a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90d:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 910:	a1 bc 11 00 00       	mov    0x11bc,%eax
 915:	eb 02                	jmp    919 <free+0x19>
 917:	89 d0                	mov    %edx,%eax
 919:	39 c8                	cmp    %ecx,%eax
 91b:	73 04                	jae    921 <free+0x21>
 91d:	39 08                	cmp    %ecx,(%eax)
 91f:	77 12                	ja     933 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 921:	8b 10                	mov    (%eax),%edx
 923:	39 c2                	cmp    %eax,%edx
 925:	77 f0                	ja     917 <free+0x17>
 927:	39 c8                	cmp    %ecx,%eax
 929:	72 08                	jb     933 <free+0x33>
 92b:	39 ca                	cmp    %ecx,%edx
 92d:	77 04                	ja     933 <free+0x33>
 92f:	89 d0                	mov    %edx,%eax
 931:	eb e6                	jmp    919 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 933:	8b 73 fc             	mov    -0x4(%ebx),%esi
 936:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 939:	8b 10                	mov    (%eax),%edx
 93b:	39 d7                	cmp    %edx,%edi
 93d:	74 19                	je     958 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 93f:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 942:	8b 50 04             	mov    0x4(%eax),%edx
 945:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 948:	39 ce                	cmp    %ecx,%esi
 94a:	74 1b                	je     967 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 94c:	89 08                	mov    %ecx,(%eax)
  freep = p;
 94e:	a3 bc 11 00 00       	mov    %eax,0x11bc
}
 953:	5b                   	pop    %ebx
 954:	5e                   	pop    %esi
 955:	5f                   	pop    %edi
 956:	5d                   	pop    %ebp
 957:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 958:	03 72 04             	add    0x4(%edx),%esi
 95b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 95e:	8b 10                	mov    (%eax),%edx
 960:	8b 12                	mov    (%edx),%edx
 962:	89 53 f8             	mov    %edx,-0x8(%ebx)
 965:	eb db                	jmp    942 <free+0x42>
    p->s.size += bp->s.size;
 967:	03 53 fc             	add    -0x4(%ebx),%edx
 96a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 96d:	8b 53 f8             	mov    -0x8(%ebx),%edx
 970:	89 10                	mov    %edx,(%eax)
 972:	eb da                	jmp    94e <free+0x4e>

00000974 <morecore>:

static Header*
morecore(uint nu)
{
 974:	55                   	push   %ebp
 975:	89 e5                	mov    %esp,%ebp
 977:	53                   	push   %ebx
 978:	83 ec 04             	sub    $0x4,%esp
 97b:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 97d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 982:	77 05                	ja     989 <morecore+0x15>
    nu = 4096;
 984:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 989:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 990:	83 ec 0c             	sub    $0xc,%esp
 993:	50                   	push   %eax
 994:	e8 f1 fc ff ff       	call   68a <sbrk>
  if(p == (char*)-1)
 999:	83 c4 10             	add    $0x10,%esp
 99c:	83 f8 ff             	cmp    $0xffffffff,%eax
 99f:	74 1c                	je     9bd <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 9a1:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9a4:	83 c0 08             	add    $0x8,%eax
 9a7:	83 ec 0c             	sub    $0xc,%esp
 9aa:	50                   	push   %eax
 9ab:	e8 50 ff ff ff       	call   900 <free>
  return freep;
 9b0:	a1 bc 11 00 00       	mov    0x11bc,%eax
 9b5:	83 c4 10             	add    $0x10,%esp
}
 9b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 9bb:	c9                   	leave  
 9bc:	c3                   	ret    
    return 0;
 9bd:	b8 00 00 00 00       	mov    $0x0,%eax
 9c2:	eb f4                	jmp    9b8 <morecore+0x44>

000009c4 <malloc>:

void*
malloc(uint nbytes)
{
 9c4:	f3 0f 1e fb          	endbr32 
 9c8:	55                   	push   %ebp
 9c9:	89 e5                	mov    %esp,%ebp
 9cb:	53                   	push   %ebx
 9cc:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9cf:	8b 45 08             	mov    0x8(%ebp),%eax
 9d2:	8d 58 07             	lea    0x7(%eax),%ebx
 9d5:	c1 eb 03             	shr    $0x3,%ebx
 9d8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 9db:	8b 0d bc 11 00 00    	mov    0x11bc,%ecx
 9e1:	85 c9                	test   %ecx,%ecx
 9e3:	74 04                	je     9e9 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e5:	8b 01                	mov    (%ecx),%eax
 9e7:	eb 4b                	jmp    a34 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 9e9:	c7 05 bc 11 00 00 c0 	movl   $0x11c0,0x11bc
 9f0:	11 00 00 
 9f3:	c7 05 c0 11 00 00 c0 	movl   $0x11c0,0x11c0
 9fa:	11 00 00 
    base.s.size = 0;
 9fd:	c7 05 c4 11 00 00 00 	movl   $0x0,0x11c4
 a04:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 a07:	b9 c0 11 00 00       	mov    $0x11c0,%ecx
 a0c:	eb d7                	jmp    9e5 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 a0e:	74 1a                	je     a2a <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 a10:	29 da                	sub    %ebx,%edx
 a12:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a15:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 a18:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 a1b:	89 0d bc 11 00 00    	mov    %ecx,0x11bc
      return (void*)(p + 1);
 a21:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a24:	83 c4 04             	add    $0x4,%esp
 a27:	5b                   	pop    %ebx
 a28:	5d                   	pop    %ebp
 a29:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 a2a:	8b 10                	mov    (%eax),%edx
 a2c:	89 11                	mov    %edx,(%ecx)
 a2e:	eb eb                	jmp    a1b <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a30:	89 c1                	mov    %eax,%ecx
 a32:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 a34:	8b 50 04             	mov    0x4(%eax),%edx
 a37:	39 da                	cmp    %ebx,%edx
 a39:	73 d3                	jae    a0e <malloc+0x4a>
    if(p == freep)
 a3b:	39 05 bc 11 00 00    	cmp    %eax,0x11bc
 a41:	75 ed                	jne    a30 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 a43:	89 d8                	mov    %ebx,%eax
 a45:	e8 2a ff ff ff       	call   974 <morecore>
 a4a:	85 c0                	test   %eax,%eax
 a4c:	75 e2                	jne    a30 <malloc+0x6c>
 a4e:	eb d4                	jmp    a24 <malloc+0x60>
