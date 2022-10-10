
_p4-test:     file format elf32-i386


Disassembly of section .text:

00000000 <createProcess>:
// Every seventh process will sleep for P4T_CHILD_SLEEP_SECONDS (whatever that
// might be). This can be used to demonstrate that sleeping processes are not
// being scheduled in the system.
int
createProcess(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
  // What time is it right now?
  int start = uptime();
   9:	e8 b0 04 00 00       	call   4be <uptime>
  // When should this process stop running?
  int end = start + (P4T_SECONDS * TPS);
   e:	8d 98 60 ea 00 00    	lea    0xea60(%eax),%ebx
  // A counter to track the pointless CPU cycles we're using
  int counter = COUNTER_START;
  // Store the return value of fork() so we know if this is the child or the
  // parent process.
  int rc = fork();
  14:	e8 05 04 00 00       	call   41e <fork>

  if (rc == 0) {
  19:	85 c0                	test   %eax,%eax
  1b:	75 59                	jne    76 <createProcess+0x76>
    // we're in the child process, now create an infinite loop
    while (1) {
      // This process will only run for 30 seconds and then exit
      if (uptime() > end) {
  1d:	e8 9c 04 00 00       	call   4be <uptime>
  22:	39 d8                	cmp    %ebx,%eax
  24:	7f 39                	jg     5f <createProcess+0x5f>
        exit();
      }

      int pid = 0;
      pid = getpid();
  26:	e8 7b 04 00 00       	call   4a6 <getpid>
  2b:	89 c1                	mov    %eax,%ecx

      // Every seventh process will take a nap and then exit.
      // The remaining processes will do some work and attempt to fall down
      // the priority queues.
      if (pid % 7 == 0) {
  2d:	ba 93 24 49 92       	mov    $0x92492493,%edx
  32:	f7 ea                	imul   %edx
  34:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  37:	c1 f8 02             	sar    $0x2,%eax
  3a:	89 ca                	mov    %ecx,%edx
  3c:	c1 fa 1f             	sar    $0x1f,%edx
  3f:	29 d0                	sub    %edx,%eax
  41:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  48:	29 c2                	sub    %eax,%edx
  4a:	39 d1                	cmp    %edx,%ecx
  4c:	74 16                	je     64 <createProcess+0x64>
  4e:	b8 80 69 67 ff       	mov    $0xff676980,%eax
        exit();
      } else {
        // These processes only perform a finite amount of work because
        // they need to check (look at the top of the while loop) if it is
        // time to exit.
        while (counter < COUNTER_END) {
  53:	3d 7f 96 98 00       	cmp    $0x98967f,%eax
  58:	7f c3                	jg     1d <createProcess+0x1d>
          ++counter;
  5a:	83 c0 01             	add    $0x1,%eax
  5d:	eb f4                	jmp    53 <createProcess+0x53>
        exit();
  5f:	e8 c2 03 00 00       	call   426 <exit>
        sleep(P4T_CHILD_SLEEP_SECONDS);
  64:	83 ec 0c             	sub    $0xc,%esp
  67:	68 20 bf 02 00       	push   $0x2bf20
  6c:	e8 45 04 00 00       	call   4b6 <sleep>
        exit();
  71:	e8 b0 03 00 00       	call   426 <exit>
  76:	89 c6                	mov    %eax,%esi
        }
      }

      counter = COUNTER_START;
    }
  } else if (rc < 0) {
  78:	78 09                	js     83 <createProcess+0x83>
    // by `p4-test&`
    printf(2, "Fork failed! Done creating\n");
  }

  return rc;
}
  7a:	89 f0                	mov    %esi,%eax
  7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  7f:	5b                   	pop    %ebx
  80:	5e                   	pop    %esi
  81:	5d                   	pop    %ebp
  82:	c3                   	ret    
    printf(2, "Fork failed! Done creating\n");
  83:	83 ec 08             	sub    $0x8,%esp
  86:	68 74 08 00 00       	push   $0x874
  8b:	6a 02                	push   $0x2
  8d:	e8 25 05 00 00       	call   5b7 <printf>
  92:	83 c4 10             	add    $0x10,%esp
  return rc;
  95:	eb e3                	jmp    7a <createProcess+0x7a>

00000097 <main>:

int
main(int argc, char* argv[])
{
  97:	f3 0f 1e fb          	endbr32 
  9b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  9f:	83 e4 f0             	and    $0xfffffff0,%esp
  a2:	ff 71 fc             	pushl  -0x4(%ecx)
  a5:	55                   	push   %ebp
  a6:	89 e5                	mov    %esp,%ebp
  a8:	56                   	push   %esi
  a9:	53                   	push   %ebx
  aa:	51                   	push   %ecx
  ab:	83 ec 0c             	sub    $0xc,%esp
  // Track the count of processes that we've created
  int pc = 0;
  ae:	be 00 00 00 00       	mov    $0x0,%esi
  // This spreads the processes out so that it should be possible to see
  // multiple queues in use at the same time.
  //
  // If, for some reason, you are not seeing that behavior, adjust the budget
  // or promotion timer accordingly.
  while (pc < P4T_MAX) {
  b3:	eb 3e                	jmp    f3 <main+0x5c>
      }
      ++pc;
    }

    printf(1, "Created %d processes. Sleeping for %d seconds.\n",
           pc % P4T_TO_CREATE ? pc % P4T_TO_CREATE : P4T_TO_CREATE,
  b5:	ba 67 66 66 66       	mov    $0x66666667,%edx
  ba:	89 f0                	mov    %esi,%eax
  bc:	f7 ea                	imul   %edx
  be:	d1 fa                	sar    %edx
  c0:	89 f0                	mov    %esi,%eax
  c2:	c1 f8 1f             	sar    $0x1f,%eax
  c5:	29 c2                	sub    %eax,%edx
  c7:	8d 04 92             	lea    (%edx,%edx,4),%eax
    printf(1, "Created %d processes. Sleeping for %d seconds.\n",
  ca:	89 f2                	mov    %esi,%edx
  cc:	29 c2                	sub    %eax,%edx
  ce:	75 05                	jne    d5 <main+0x3e>
  d0:	ba 05 00 00 00       	mov    $0x5,%edx
  d5:	6a 01                	push   $0x1
  d7:	52                   	push   %edx
  d8:	68 b0 08 00 00       	push   $0x8b0
  dd:	6a 01                	push   $0x1
  df:	e8 d3 04 00 00       	call   5b7 <printf>
           P4T_PARENT_SLEEP_SECONDS);
    sleep(P4T_PARENT_SLEEP_SECONDS * TPS);
  e4:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
  eb:	e8 c6 03 00 00       	call   4b6 <sleep>
  f0:	83 c4 10             	add    $0x10,%esp
  while (pc < P4T_MAX) {
  f3:	83 fe 3b             	cmp    $0x3b,%esi
  f6:	7f 1c                	jg     114 <main+0x7d>
    for (i = 0; i < P4T_TO_CREATE; ++i) {
  f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  fd:	83 fb 04             	cmp    $0x4,%ebx
 100:	7f b3                	jg     b5 <main+0x1e>
      if (createProcess() == -1) {
 102:	e8 f9 fe ff ff       	call   0 <createProcess>
 107:	83 f8 ff             	cmp    $0xffffffff,%eax
 10a:	74 a9                	je     b5 <main+0x1e>
      ++pc;
 10c:	83 c6 01             	add    $0x1,%esi
    for (i = 0; i < P4T_TO_CREATE; ++i) {
 10f:	83 c3 01             	add    $0x1,%ebx
 112:	eb e9                	jmp    fd <main+0x66>
  }

  printf(1, "Created %d processes.\n", pc);
 114:	83 ec 04             	sub    $0x4,%esp
 117:	56                   	push   %esi
 118:	68 90 08 00 00       	push   $0x890
 11d:	6a 01                	push   $0x1
 11f:	e8 93 04 00 00       	call   5b7 <printf>

  // Loop for approximately one minute while prompting for action.
  for (i = 0; i < 6; ++i) {
 124:	83 c4 10             	add    $0x10,%esp
 127:	bb 00 00 00 00       	mov    $0x0,%ebx
 12c:	83 fb 05             	cmp    $0x5,%ebx
 12f:	7f 41                	jg     172 <main+0xdb>
    // Prompt for action!
    printf(1, "Now verify that your system is working by pressing C-p and then C-r.\n");
 131:	83 ec 08             	sub    $0x8,%esp
 134:	68 e0 08 00 00       	push   $0x8e0
 139:	6a 01                	push   $0x1
 13b:	e8 77 04 00 00       	call   5b7 <printf>
    // Now sleep for 10 seconds so the user can actually do something
    sleep(10 * TPS);
 140:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
 147:	e8 6a 03 00 00       	call   4b6 <sleep>
  for (i = 0; i < 6; ++i) {
 14c:	83 c3 01             	add    $0x1,%ebx
 14f:	83 c4 10             	add    $0x10,%esp
 152:	eb d8                	jmp    12c <main+0x95>

  // Just make sure that all child processes have exited so we don't leave
  // orphaned processes hanging around. If there are any child processes,
  // print a helpful message and then sleep for 1 second.
  while (wait() != -1) {
    printf(1, "Waiting on all child processes to exit...\n");
 154:	83 ec 08             	sub    $0x8,%esp
 157:	68 28 09 00 00       	push   $0x928
 15c:	6a 01                	push   $0x1
 15e:	e8 54 04 00 00       	call   5b7 <printf>
    sleep(TPS);
 163:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
 16a:	e8 47 03 00 00       	call   4b6 <sleep>
 16f:	83 c4 10             	add    $0x10,%esp
  while (wait() != -1) {
 172:	e8 b7 02 00 00       	call   42e <wait>
 177:	83 f8 ff             	cmp    $0xffffffff,%eax
 17a:	75 d8                	jne    154 <main+0xbd>
  }

  printf(1, "Done!\n");
 17c:	83 ec 08             	sub    $0x8,%esp
 17f:	68 a7 08 00 00       	push   $0x8a7
 184:	6a 01                	push   $0x1
 186:	e8 2c 04 00 00       	call   5b7 <printf>

  exit();
 18b:	e8 96 02 00 00       	call   426 <exit>

00000190 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 190:	f3 0f 1e fb          	endbr32 
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	56                   	push   %esi
 198:	53                   	push   %ebx
 199:	8b 75 08             	mov    0x8(%ebp),%esi
 19c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 19f:	89 f0                	mov    %esi,%eax
 1a1:	89 d1                	mov    %edx,%ecx
 1a3:	83 c2 01             	add    $0x1,%edx
 1a6:	89 c3                	mov    %eax,%ebx
 1a8:	83 c0 01             	add    $0x1,%eax
 1ab:	0f b6 09             	movzbl (%ecx),%ecx
 1ae:	88 0b                	mov    %cl,(%ebx)
 1b0:	84 c9                	test   %cl,%cl
 1b2:	75 ed                	jne    1a1 <strcpy+0x11>
    ;
  return os;
}
 1b4:	89 f0                	mov    %esi,%eax
 1b6:	5b                   	pop    %ebx
 1b7:	5e                   	pop    %esi
 1b8:	5d                   	pop    %ebp
 1b9:	c3                   	ret    

000001ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ba:	f3 0f 1e fb          	endbr32 
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1c7:	0f b6 01             	movzbl (%ecx),%eax
 1ca:	84 c0                	test   %al,%al
 1cc:	74 0c                	je     1da <strcmp+0x20>
 1ce:	3a 02                	cmp    (%edx),%al
 1d0:	75 08                	jne    1da <strcmp+0x20>
    p++, q++;
 1d2:	83 c1 01             	add    $0x1,%ecx
 1d5:	83 c2 01             	add    $0x1,%edx
 1d8:	eb ed                	jmp    1c7 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 1da:	0f b6 c0             	movzbl %al,%eax
 1dd:	0f b6 12             	movzbl (%edx),%edx
 1e0:	29 d0                	sub    %edx,%eax
}
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    

000001e4 <strlen>:

uint
strlen(char *s)
{
 1e4:	f3 0f 1e fb          	endbr32 
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1ee:	b8 00 00 00 00       	mov    $0x0,%eax
 1f3:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 1f7:	74 05                	je     1fe <strlen+0x1a>
 1f9:	83 c0 01             	add    $0x1,%eax
 1fc:	eb f5                	jmp    1f3 <strlen+0xf>
    ;
  return n;
}
 1fe:	5d                   	pop    %ebp
 1ff:	c3                   	ret    

00000200 <memset>:

void*
memset(void *dst, int c, uint n)
{
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	57                   	push   %edi
 208:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 20b:	89 d7                	mov    %edx,%edi
 20d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 210:	8b 45 0c             	mov    0xc(%ebp),%eax
 213:	fc                   	cld    
 214:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 216:	89 d0                	mov    %edx,%eax
 218:	5f                   	pop    %edi
 219:	5d                   	pop    %ebp
 21a:	c3                   	ret    

0000021b <strchr>:

char*
strchr(const char *s, char c)
{
 21b:	f3 0f 1e fb          	endbr32 
 21f:	55                   	push   %ebp
 220:	89 e5                	mov    %esp,%ebp
 222:	8b 45 08             	mov    0x8(%ebp),%eax
 225:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 229:	0f b6 10             	movzbl (%eax),%edx
 22c:	84 d2                	test   %dl,%dl
 22e:	74 09                	je     239 <strchr+0x1e>
    if(*s == c)
 230:	38 ca                	cmp    %cl,%dl
 232:	74 0a                	je     23e <strchr+0x23>
  for(; *s; s++)
 234:	83 c0 01             	add    $0x1,%eax
 237:	eb f0                	jmp    229 <strchr+0xe>
      return (char*)s;
  return 0;
 239:	b8 00 00 00 00       	mov    $0x0,%eax
}
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    

00000240 <gets>:

char*
gets(char *buf, int max)
{
 240:	f3 0f 1e fb          	endbr32 
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	57                   	push   %edi
 248:	56                   	push   %esi
 249:	53                   	push   %ebx
 24a:	83 ec 1c             	sub    $0x1c,%esp
 24d:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 250:	bb 00 00 00 00       	mov    $0x0,%ebx
 255:	89 de                	mov    %ebx,%esi
 257:	83 c3 01             	add    $0x1,%ebx
 25a:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 25d:	7d 2e                	jge    28d <gets+0x4d>
    cc = read(0, &c, 1);
 25f:	83 ec 04             	sub    $0x4,%esp
 262:	6a 01                	push   $0x1
 264:	8d 45 e7             	lea    -0x19(%ebp),%eax
 267:	50                   	push   %eax
 268:	6a 00                	push   $0x0
 26a:	e8 cf 01 00 00       	call   43e <read>
    if(cc < 1)
 26f:	83 c4 10             	add    $0x10,%esp
 272:	85 c0                	test   %eax,%eax
 274:	7e 17                	jle    28d <gets+0x4d>
      break;
    buf[i++] = c;
 276:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 27a:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 27d:	3c 0a                	cmp    $0xa,%al
 27f:	0f 94 c2             	sete   %dl
 282:	3c 0d                	cmp    $0xd,%al
 284:	0f 94 c0             	sete   %al
 287:	08 c2                	or     %al,%dl
 289:	74 ca                	je     255 <gets+0x15>
    buf[i++] = c;
 28b:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 28d:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 291:	89 f8                	mov    %edi,%eax
 293:	8d 65 f4             	lea    -0xc(%ebp),%esp
 296:	5b                   	pop    %ebx
 297:	5e                   	pop    %esi
 298:	5f                   	pop    %edi
 299:	5d                   	pop    %ebp
 29a:	c3                   	ret    

0000029b <stat>:

int
stat(char *n, struct stat *st)
{
 29b:	f3 0f 1e fb          	endbr32 
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	56                   	push   %esi
 2a3:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a4:	83 ec 08             	sub    $0x8,%esp
 2a7:	6a 00                	push   $0x0
 2a9:	ff 75 08             	pushl  0x8(%ebp)
 2ac:	e8 b5 01 00 00       	call   466 <open>
  if(fd < 0)
 2b1:	83 c4 10             	add    $0x10,%esp
 2b4:	85 c0                	test   %eax,%eax
 2b6:	78 24                	js     2dc <stat+0x41>
 2b8:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2ba:	83 ec 08             	sub    $0x8,%esp
 2bd:	ff 75 0c             	pushl  0xc(%ebp)
 2c0:	50                   	push   %eax
 2c1:	e8 b8 01 00 00       	call   47e <fstat>
 2c6:	89 c6                	mov    %eax,%esi
  close(fd);
 2c8:	89 1c 24             	mov    %ebx,(%esp)
 2cb:	e8 7e 01 00 00       	call   44e <close>
  return r;
 2d0:	83 c4 10             	add    $0x10,%esp
}
 2d3:	89 f0                	mov    %esi,%eax
 2d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2d8:	5b                   	pop    %ebx
 2d9:	5e                   	pop    %esi
 2da:	5d                   	pop    %ebp
 2db:	c3                   	ret    
    return -1;
 2dc:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2e1:	eb f0                	jmp    2d3 <stat+0x38>

000002e3 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 2e3:	f3 0f 1e fb          	endbr32 
 2e7:	55                   	push   %ebp
 2e8:	89 e5                	mov    %esp,%ebp
 2ea:	57                   	push   %edi
 2eb:	56                   	push   %esi
 2ec:	53                   	push   %ebx
 2ed:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2f0:	0f b6 02             	movzbl (%edx),%eax
 2f3:	3c 20                	cmp    $0x20,%al
 2f5:	75 05                	jne    2fc <atoi+0x19>
 2f7:	83 c2 01             	add    $0x1,%edx
 2fa:	eb f4                	jmp    2f0 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 2fc:	3c 2d                	cmp    $0x2d,%al
 2fe:	74 1d                	je     31d <atoi+0x3a>
 300:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 305:	3c 2b                	cmp    $0x2b,%al
 307:	0f 94 c1             	sete   %cl
 30a:	3c 2d                	cmp    $0x2d,%al
 30c:	0f 94 c0             	sete   %al
 30f:	08 c1                	or     %al,%cl
 311:	74 03                	je     316 <atoi+0x33>
    s++;
 313:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 316:	b8 00 00 00 00       	mov    $0x0,%eax
 31b:	eb 17                	jmp    334 <atoi+0x51>
 31d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 322:	eb e1                	jmp    305 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 324:	8d 34 80             	lea    (%eax,%eax,4),%esi
 327:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 32a:	83 c2 01             	add    $0x1,%edx
 32d:	0f be c9             	movsbl %cl,%ecx
 330:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 334:	0f b6 0a             	movzbl (%edx),%ecx
 337:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 33a:	80 fb 09             	cmp    $0x9,%bl
 33d:	76 e5                	jbe    324 <atoi+0x41>
  return sign*n;
 33f:	0f af c7             	imul   %edi,%eax
}
 342:	5b                   	pop    %ebx
 343:	5e                   	pop    %esi
 344:	5f                   	pop    %edi
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    

00000347 <atoo>:

int
atoo(const char *s)
{
 347:	f3 0f 1e fb          	endbr32 
 34b:	55                   	push   %ebp
 34c:	89 e5                	mov    %esp,%ebp
 34e:	57                   	push   %edi
 34f:	56                   	push   %esi
 350:	53                   	push   %ebx
 351:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 354:	0f b6 0a             	movzbl (%edx),%ecx
 357:	80 f9 20             	cmp    $0x20,%cl
 35a:	75 05                	jne    361 <atoo+0x1a>
 35c:	83 c2 01             	add    $0x1,%edx
 35f:	eb f3                	jmp    354 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 361:	80 f9 2d             	cmp    $0x2d,%cl
 364:	74 23                	je     389 <atoo+0x42>
 366:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 36b:	80 f9 2b             	cmp    $0x2b,%cl
 36e:	0f 94 c0             	sete   %al
 371:	89 c6                	mov    %eax,%esi
 373:	80 f9 2d             	cmp    $0x2d,%cl
 376:	0f 94 c0             	sete   %al
 379:	89 f3                	mov    %esi,%ebx
 37b:	08 c3                	or     %al,%bl
 37d:	74 03                	je     382 <atoo+0x3b>
    s++;
 37f:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 382:	b8 00 00 00 00       	mov    $0x0,%eax
 387:	eb 11                	jmp    39a <atoo+0x53>
 389:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 38e:	eb db                	jmp    36b <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 390:	83 c2 01             	add    $0x1,%edx
 393:	0f be c9             	movsbl %cl,%ecx
 396:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 39a:	0f b6 0a             	movzbl (%edx),%ecx
 39d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 3a0:	80 fb 07             	cmp    $0x7,%bl
 3a3:	76 eb                	jbe    390 <atoo+0x49>
  return sign*n;
 3a5:	0f af c7             	imul   %edi,%eax
}
 3a8:	5b                   	pop    %ebx
 3a9:	5e                   	pop    %esi
 3aa:	5f                   	pop    %edi
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    

000003ad <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 3ad:	f3 0f 1e fb          	endbr32 
 3b1:	55                   	push   %ebp
 3b2:	89 e5                	mov    %esp,%ebp
 3b4:	53                   	push   %ebx
 3b5:	8b 55 08             	mov    0x8(%ebp),%edx
 3b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 3bb:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 3be:	eb 09                	jmp    3c9 <strncmp+0x1c>
      n--, p++, q++;
 3c0:	83 e8 01             	sub    $0x1,%eax
 3c3:	83 c2 01             	add    $0x1,%edx
 3c6:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 3c9:	85 c0                	test   %eax,%eax
 3cb:	74 0b                	je     3d8 <strncmp+0x2b>
 3cd:	0f b6 1a             	movzbl (%edx),%ebx
 3d0:	84 db                	test   %bl,%bl
 3d2:	74 04                	je     3d8 <strncmp+0x2b>
 3d4:	3a 19                	cmp    (%ecx),%bl
 3d6:	74 e8                	je     3c0 <strncmp+0x13>
    if(n == 0)
 3d8:	85 c0                	test   %eax,%eax
 3da:	74 0b                	je     3e7 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 3dc:	0f b6 02             	movzbl (%edx),%eax
 3df:	0f b6 11             	movzbl (%ecx),%edx
 3e2:	29 d0                	sub    %edx,%eax
}
 3e4:	5b                   	pop    %ebx
 3e5:	5d                   	pop    %ebp
 3e6:	c3                   	ret    
      return 0;
 3e7:	b8 00 00 00 00       	mov    $0x0,%eax
 3ec:	eb f6                	jmp    3e4 <strncmp+0x37>

000003ee <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 3ee:	f3 0f 1e fb          	endbr32 
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	56                   	push   %esi
 3f6:	53                   	push   %ebx
 3f7:	8b 75 08             	mov    0x8(%ebp),%esi
 3fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 3fd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 400:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 402:	8d 58 ff             	lea    -0x1(%eax),%ebx
 405:	85 c0                	test   %eax,%eax
 407:	7e 0f                	jle    418 <memmove+0x2a>
    *dst++ = *src++;
 409:	0f b6 01             	movzbl (%ecx),%eax
 40c:	88 02                	mov    %al,(%edx)
 40e:	8d 49 01             	lea    0x1(%ecx),%ecx
 411:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 414:	89 d8                	mov    %ebx,%eax
 416:	eb ea                	jmp    402 <memmove+0x14>
  return vdst;
}
 418:	89 f0                	mov    %esi,%eax
 41a:	5b                   	pop    %ebx
 41b:	5e                   	pop    %esi
 41c:	5d                   	pop    %ebp
 41d:	c3                   	ret    

0000041e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 41e:	b8 01 00 00 00       	mov    $0x1,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <exit>:
SYSCALL(exit)
 426:	b8 02 00 00 00       	mov    $0x2,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <wait>:
SYSCALL(wait)
 42e:	b8 03 00 00 00       	mov    $0x3,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <pipe>:
SYSCALL(pipe)
 436:	b8 04 00 00 00       	mov    $0x4,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <read>:
SYSCALL(read)
 43e:	b8 05 00 00 00       	mov    $0x5,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <write>:
SYSCALL(write)
 446:	b8 10 00 00 00       	mov    $0x10,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <close>:
SYSCALL(close)
 44e:	b8 15 00 00 00       	mov    $0x15,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <kill>:
SYSCALL(kill)
 456:	b8 06 00 00 00       	mov    $0x6,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <exec>:
SYSCALL(exec)
 45e:	b8 07 00 00 00       	mov    $0x7,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <open>:
SYSCALL(open)
 466:	b8 0f 00 00 00       	mov    $0xf,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <mknod>:
SYSCALL(mknod)
 46e:	b8 11 00 00 00       	mov    $0x11,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <unlink>:
SYSCALL(unlink)
 476:	b8 12 00 00 00       	mov    $0x12,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <fstat>:
SYSCALL(fstat)
 47e:	b8 08 00 00 00       	mov    $0x8,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <link>:
SYSCALL(link)
 486:	b8 13 00 00 00       	mov    $0x13,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <mkdir>:
SYSCALL(mkdir)
 48e:	b8 14 00 00 00       	mov    $0x14,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <chdir>:
SYSCALL(chdir)
 496:	b8 09 00 00 00       	mov    $0x9,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <dup>:
SYSCALL(dup)
 49e:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <getpid>:
SYSCALL(getpid)
 4a6:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <sbrk>:
SYSCALL(sbrk)
 4ae:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <sleep>:
SYSCALL(sleep)
 4b6:	b8 0d 00 00 00       	mov    $0xd,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <uptime>:
SYSCALL(uptime)
 4be:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <halt>:
SYSCALL(halt)
 4c6:	b8 16 00 00 00       	mov    $0x16,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <date>:
SYSCALL(date)
 4ce:	b8 17 00 00 00       	mov    $0x17,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <getuid>:
SYSCALL(getuid)
 4d6:	b8 18 00 00 00       	mov    $0x18,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <getgid>:
SYSCALL(getgid)
 4de:	b8 19 00 00 00       	mov    $0x19,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <getppid>:
SYSCALL(getppid)
 4e6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <setuid>:
SYSCALL(setuid)
 4ee:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <setgid>:
SYSCALL(setgid)
 4f6:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <getprocs>:
SYSCALL(getprocs)
 4fe:	b8 1d 00 00 00       	mov    $0x1d,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <setpriority>:
SYSCALL(setpriority)
 506:	b8 1e 00 00 00       	mov    $0x1e,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <getpriority>:
SYSCALL(getpriority)
 50e:	b8 1f 00 00 00       	mov    $0x1f,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 516:	55                   	push   %ebp
 517:	89 e5                	mov    %esp,%ebp
 519:	83 ec 1c             	sub    $0x1c,%esp
 51c:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 51f:	6a 01                	push   $0x1
 521:	8d 55 f4             	lea    -0xc(%ebp),%edx
 524:	52                   	push   %edx
 525:	50                   	push   %eax
 526:	e8 1b ff ff ff       	call   446 <write>
}
 52b:	83 c4 10             	add    $0x10,%esp
 52e:	c9                   	leave  
 52f:	c3                   	ret    

00000530 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	83 ec 2c             	sub    $0x2c,%esp
 539:	89 45 d0             	mov    %eax,-0x30(%ebp)
 53c:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 53e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 542:	0f 95 c2             	setne  %dl
 545:	89 f0                	mov    %esi,%eax
 547:	c1 e8 1f             	shr    $0x1f,%eax
 54a:	84 c2                	test   %al,%dl
 54c:	74 42                	je     590 <printint+0x60>
    neg = 1;
    x = -xx;
 54e:	f7 de                	neg    %esi
    neg = 1;
 550:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 557:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 55c:	89 f0                	mov    %esi,%eax
 55e:	ba 00 00 00 00       	mov    $0x0,%edx
 563:	f7 f1                	div    %ecx
 565:	89 df                	mov    %ebx,%edi
 567:	83 c3 01             	add    $0x1,%ebx
 56a:	0f b6 92 5c 09 00 00 	movzbl 0x95c(%edx),%edx
 571:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 575:	89 f2                	mov    %esi,%edx
 577:	89 c6                	mov    %eax,%esi
 579:	39 d1                	cmp    %edx,%ecx
 57b:	76 df                	jbe    55c <printint+0x2c>
  if(neg)
 57d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 581:	74 2f                	je     5b2 <printint+0x82>
    buf[i++] = '-';
 583:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 588:	8d 5f 02             	lea    0x2(%edi),%ebx
 58b:	8b 75 d0             	mov    -0x30(%ebp),%esi
 58e:	eb 15                	jmp    5a5 <printint+0x75>
  neg = 0;
 590:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 597:	eb be                	jmp    557 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 599:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 59e:	89 f0                	mov    %esi,%eax
 5a0:	e8 71 ff ff ff       	call   516 <putc>
  while(--i >= 0)
 5a5:	83 eb 01             	sub    $0x1,%ebx
 5a8:	79 ef                	jns    599 <printint+0x69>
}
 5aa:	83 c4 2c             	add    $0x2c,%esp
 5ad:	5b                   	pop    %ebx
 5ae:	5e                   	pop    %esi
 5af:	5f                   	pop    %edi
 5b0:	5d                   	pop    %ebp
 5b1:	c3                   	ret    
 5b2:	8b 75 d0             	mov    -0x30(%ebp),%esi
 5b5:	eb ee                	jmp    5a5 <printint+0x75>

000005b7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5b7:	f3 0f 1e fb          	endbr32 
 5bb:	55                   	push   %ebp
 5bc:	89 e5                	mov    %esp,%ebp
 5be:	57                   	push   %edi
 5bf:	56                   	push   %esi
 5c0:	53                   	push   %ebx
 5c1:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5c4:	8d 45 10             	lea    0x10(%ebp),%eax
 5c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 5ca:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5cf:	bb 00 00 00 00       	mov    $0x0,%ebx
 5d4:	eb 14                	jmp    5ea <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5d6:	89 fa                	mov    %edi,%edx
 5d8:	8b 45 08             	mov    0x8(%ebp),%eax
 5db:	e8 36 ff ff ff       	call   516 <putc>
 5e0:	eb 05                	jmp    5e7 <printf+0x30>
      }
    } else if(state == '%'){
 5e2:	83 fe 25             	cmp    $0x25,%esi
 5e5:	74 25                	je     60c <printf+0x55>
  for(i = 0; fmt[i]; i++){
 5e7:	83 c3 01             	add    $0x1,%ebx
 5ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ed:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 5f1:	84 c0                	test   %al,%al
 5f3:	0f 84 23 01 00 00    	je     71c <printf+0x165>
    c = fmt[i] & 0xff;
 5f9:	0f be f8             	movsbl %al,%edi
 5fc:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 5ff:	85 f6                	test   %esi,%esi
 601:	75 df                	jne    5e2 <printf+0x2b>
      if(c == '%'){
 603:	83 f8 25             	cmp    $0x25,%eax
 606:	75 ce                	jne    5d6 <printf+0x1f>
        state = '%';
 608:	89 c6                	mov    %eax,%esi
 60a:	eb db                	jmp    5e7 <printf+0x30>
      if(c == 'd'){
 60c:	83 f8 64             	cmp    $0x64,%eax
 60f:	74 49                	je     65a <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 611:	83 f8 78             	cmp    $0x78,%eax
 614:	0f 94 c1             	sete   %cl
 617:	83 f8 70             	cmp    $0x70,%eax
 61a:	0f 94 c2             	sete   %dl
 61d:	08 d1                	or     %dl,%cl
 61f:	75 63                	jne    684 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 621:	83 f8 73             	cmp    $0x73,%eax
 624:	0f 84 84 00 00 00    	je     6ae <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62a:	83 f8 63             	cmp    $0x63,%eax
 62d:	0f 84 b7 00 00 00    	je     6ea <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 633:	83 f8 25             	cmp    $0x25,%eax
 636:	0f 84 cc 00 00 00    	je     708 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63c:	ba 25 00 00 00       	mov    $0x25,%edx
 641:	8b 45 08             	mov    0x8(%ebp),%eax
 644:	e8 cd fe ff ff       	call   516 <putc>
        putc(fd, c);
 649:	89 fa                	mov    %edi,%edx
 64b:	8b 45 08             	mov    0x8(%ebp),%eax
 64e:	e8 c3 fe ff ff       	call   516 <putc>
      }
      state = 0;
 653:	be 00 00 00 00       	mov    $0x0,%esi
 658:	eb 8d                	jmp    5e7 <printf+0x30>
        printint(fd, *ap, 10, 1);
 65a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 65d:	8b 17                	mov    (%edi),%edx
 65f:	83 ec 0c             	sub    $0xc,%esp
 662:	6a 01                	push   $0x1
 664:	b9 0a 00 00 00       	mov    $0xa,%ecx
 669:	8b 45 08             	mov    0x8(%ebp),%eax
 66c:	e8 bf fe ff ff       	call   530 <printint>
        ap++;
 671:	83 c7 04             	add    $0x4,%edi
 674:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 677:	83 c4 10             	add    $0x10,%esp
      state = 0;
 67a:	be 00 00 00 00       	mov    $0x0,%esi
 67f:	e9 63 ff ff ff       	jmp    5e7 <printf+0x30>
        printint(fd, *ap, 16, 0);
 684:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 687:	8b 17                	mov    (%edi),%edx
 689:	83 ec 0c             	sub    $0xc,%esp
 68c:	6a 00                	push   $0x0
 68e:	b9 10 00 00 00       	mov    $0x10,%ecx
 693:	8b 45 08             	mov    0x8(%ebp),%eax
 696:	e8 95 fe ff ff       	call   530 <printint>
        ap++;
 69b:	83 c7 04             	add    $0x4,%edi
 69e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6a1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6a4:	be 00 00 00 00       	mov    $0x0,%esi
 6a9:	e9 39 ff ff ff       	jmp    5e7 <printf+0x30>
        s = (char*)*ap;
 6ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b1:	8b 30                	mov    (%eax),%esi
        ap++;
 6b3:	83 c0 04             	add    $0x4,%eax
 6b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 6b9:	85 f6                	test   %esi,%esi
 6bb:	75 28                	jne    6e5 <printf+0x12e>
          s = "(null)";
 6bd:	be 53 09 00 00       	mov    $0x953,%esi
 6c2:	8b 7d 08             	mov    0x8(%ebp),%edi
 6c5:	eb 0d                	jmp    6d4 <printf+0x11d>
          putc(fd, *s);
 6c7:	0f be d2             	movsbl %dl,%edx
 6ca:	89 f8                	mov    %edi,%eax
 6cc:	e8 45 fe ff ff       	call   516 <putc>
          s++;
 6d1:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 6d4:	0f b6 16             	movzbl (%esi),%edx
 6d7:	84 d2                	test   %dl,%dl
 6d9:	75 ec                	jne    6c7 <printf+0x110>
      state = 0;
 6db:	be 00 00 00 00       	mov    $0x0,%esi
 6e0:	e9 02 ff ff ff       	jmp    5e7 <printf+0x30>
 6e5:	8b 7d 08             	mov    0x8(%ebp),%edi
 6e8:	eb ea                	jmp    6d4 <printf+0x11d>
        putc(fd, *ap);
 6ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6ed:	0f be 17             	movsbl (%edi),%edx
 6f0:	8b 45 08             	mov    0x8(%ebp),%eax
 6f3:	e8 1e fe ff ff       	call   516 <putc>
        ap++;
 6f8:	83 c7 04             	add    $0x4,%edi
 6fb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 6fe:	be 00 00 00 00       	mov    $0x0,%esi
 703:	e9 df fe ff ff       	jmp    5e7 <printf+0x30>
        putc(fd, c);
 708:	89 fa                	mov    %edi,%edx
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	e8 04 fe ff ff       	call   516 <putc>
      state = 0;
 712:	be 00 00 00 00       	mov    $0x0,%esi
 717:	e9 cb fe ff ff       	jmp    5e7 <printf+0x30>
    }
  }
}
 71c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 71f:	5b                   	pop    %ebx
 720:	5e                   	pop    %esi
 721:	5f                   	pop    %edi
 722:	5d                   	pop    %ebp
 723:	c3                   	ret    

00000724 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 724:	f3 0f 1e fb          	endbr32 
 728:	55                   	push   %ebp
 729:	89 e5                	mov    %esp,%ebp
 72b:	57                   	push   %edi
 72c:	56                   	push   %esi
 72d:	53                   	push   %ebx
 72e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 731:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 734:	a1 8c 0c 00 00       	mov    0xc8c,%eax
 739:	eb 02                	jmp    73d <free+0x19>
 73b:	89 d0                	mov    %edx,%eax
 73d:	39 c8                	cmp    %ecx,%eax
 73f:	73 04                	jae    745 <free+0x21>
 741:	39 08                	cmp    %ecx,(%eax)
 743:	77 12                	ja     757 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 745:	8b 10                	mov    (%eax),%edx
 747:	39 c2                	cmp    %eax,%edx
 749:	77 f0                	ja     73b <free+0x17>
 74b:	39 c8                	cmp    %ecx,%eax
 74d:	72 08                	jb     757 <free+0x33>
 74f:	39 ca                	cmp    %ecx,%edx
 751:	77 04                	ja     757 <free+0x33>
 753:	89 d0                	mov    %edx,%eax
 755:	eb e6                	jmp    73d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 757:	8b 73 fc             	mov    -0x4(%ebx),%esi
 75a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 75d:	8b 10                	mov    (%eax),%edx
 75f:	39 d7                	cmp    %edx,%edi
 761:	74 19                	je     77c <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 763:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 766:	8b 50 04             	mov    0x4(%eax),%edx
 769:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 76c:	39 ce                	cmp    %ecx,%esi
 76e:	74 1b                	je     78b <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 770:	89 08                	mov    %ecx,(%eax)
  freep = p;
 772:	a3 8c 0c 00 00       	mov    %eax,0xc8c
}
 777:	5b                   	pop    %ebx
 778:	5e                   	pop    %esi
 779:	5f                   	pop    %edi
 77a:	5d                   	pop    %ebp
 77b:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 77c:	03 72 04             	add    0x4(%edx),%esi
 77f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 782:	8b 10                	mov    (%eax),%edx
 784:	8b 12                	mov    (%edx),%edx
 786:	89 53 f8             	mov    %edx,-0x8(%ebx)
 789:	eb db                	jmp    766 <free+0x42>
    p->s.size += bp->s.size;
 78b:	03 53 fc             	add    -0x4(%ebx),%edx
 78e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 791:	8b 53 f8             	mov    -0x8(%ebx),%edx
 794:	89 10                	mov    %edx,(%eax)
 796:	eb da                	jmp    772 <free+0x4e>

00000798 <morecore>:

static Header*
morecore(uint nu)
{
 798:	55                   	push   %ebp
 799:	89 e5                	mov    %esp,%ebp
 79b:	53                   	push   %ebx
 79c:	83 ec 04             	sub    $0x4,%esp
 79f:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 7a1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 7a6:	77 05                	ja     7ad <morecore+0x15>
    nu = 4096;
 7a8:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 7ad:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 7b4:	83 ec 0c             	sub    $0xc,%esp
 7b7:	50                   	push   %eax
 7b8:	e8 f1 fc ff ff       	call   4ae <sbrk>
  if(p == (char*)-1)
 7bd:	83 c4 10             	add    $0x10,%esp
 7c0:	83 f8 ff             	cmp    $0xffffffff,%eax
 7c3:	74 1c                	je     7e1 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7c5:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7c8:	83 c0 08             	add    $0x8,%eax
 7cb:	83 ec 0c             	sub    $0xc,%esp
 7ce:	50                   	push   %eax
 7cf:	e8 50 ff ff ff       	call   724 <free>
  return freep;
 7d4:	a1 8c 0c 00 00       	mov    0xc8c,%eax
 7d9:	83 c4 10             	add    $0x10,%esp
}
 7dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7df:	c9                   	leave  
 7e0:	c3                   	ret    
    return 0;
 7e1:	b8 00 00 00 00       	mov    $0x0,%eax
 7e6:	eb f4                	jmp    7dc <morecore+0x44>

000007e8 <malloc>:

void*
malloc(uint nbytes)
{
 7e8:	f3 0f 1e fb          	endbr32 
 7ec:	55                   	push   %ebp
 7ed:	89 e5                	mov    %esp,%ebp
 7ef:	53                   	push   %ebx
 7f0:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f3:	8b 45 08             	mov    0x8(%ebp),%eax
 7f6:	8d 58 07             	lea    0x7(%eax),%ebx
 7f9:	c1 eb 03             	shr    $0x3,%ebx
 7fc:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 7ff:	8b 0d 8c 0c 00 00    	mov    0xc8c,%ecx
 805:	85 c9                	test   %ecx,%ecx
 807:	74 04                	je     80d <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 809:	8b 01                	mov    (%ecx),%eax
 80b:	eb 4b                	jmp    858 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 80d:	c7 05 8c 0c 00 00 90 	movl   $0xc90,0xc8c
 814:	0c 00 00 
 817:	c7 05 90 0c 00 00 90 	movl   $0xc90,0xc90
 81e:	0c 00 00 
    base.s.size = 0;
 821:	c7 05 94 0c 00 00 00 	movl   $0x0,0xc94
 828:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 82b:	b9 90 0c 00 00       	mov    $0xc90,%ecx
 830:	eb d7                	jmp    809 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 832:	74 1a                	je     84e <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 834:	29 da                	sub    %ebx,%edx
 836:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 839:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 83c:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 83f:	89 0d 8c 0c 00 00    	mov    %ecx,0xc8c
      return (void*)(p + 1);
 845:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 848:	83 c4 04             	add    $0x4,%esp
 84b:	5b                   	pop    %ebx
 84c:	5d                   	pop    %ebp
 84d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 84e:	8b 10                	mov    (%eax),%edx
 850:	89 11                	mov    %edx,(%ecx)
 852:	eb eb                	jmp    83f <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 854:	89 c1                	mov    %eax,%ecx
 856:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 858:	8b 50 04             	mov    0x4(%eax),%edx
 85b:	39 da                	cmp    %ebx,%edx
 85d:	73 d3                	jae    832 <malloc+0x4a>
    if(p == freep)
 85f:	39 05 8c 0c 00 00    	cmp    %eax,0xc8c
 865:	75 ed                	jne    854 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 867:	89 d8                	mov    %ebx,%eax
 869:	e8 2a ff ff ff       	call   798 <morecore>
 86e:	85 c0                	test   %eax,%eax
 870:	75 e2                	jne    854 <malloc+0x6c>
 872:	eb d4                	jmp    848 <malloc+0x60>
