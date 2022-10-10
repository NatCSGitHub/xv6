
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 90 ed 10 80       	mov    $0x8010ed90,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c6 2b 10 80       	mov    $0x80102bc6,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 a0 ed 10 80       	push   $0x8010eda0
80100046:	e8 50 50 00 00       	call   8010509b <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d f0 34 11 80    	mov    0x801134f0,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb 9c 34 11 80    	cmp    $0x8011349c,%ebx
8010005f:	74 30                	je     80100091 <bget+0x5d>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	83 c0 01             	add    $0x1,%eax
80100071:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100074:	83 ec 0c             	sub    $0xc,%esp
80100077:	68 a0 ed 10 80       	push   $0x8010eda0
8010007c:	e8 83 50 00 00       	call   80105104 <release>
      acquiresleep(&b->lock);
80100081:	8d 43 0c             	lea    0xc(%ebx),%eax
80100084:	89 04 24             	mov    %eax,(%esp)
80100087:	e8 02 4e 00 00       	call   80104e8e <acquiresleep>
      return b;
8010008c:	83 c4 10             	add    $0x10,%esp
8010008f:	eb 4c                	jmp    801000dd <bget+0xa9>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100091:	8b 1d ec 34 11 80    	mov    0x801134ec,%ebx
80100097:	eb 03                	jmp    8010009c <bget+0x68>
80100099:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009c:	81 fb 9c 34 11 80    	cmp    $0x8011349c,%ebx
801000a2:	74 43                	je     801000e7 <bget+0xb3>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a4:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a8:	75 ef                	jne    80100099 <bget+0x65>
801000aa:	f6 03 04             	testb  $0x4,(%ebx)
801000ad:	75 ea                	jne    80100099 <bget+0x65>
      b->dev = dev;
801000af:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b2:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000bb:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c2:	83 ec 0c             	sub    $0xc,%esp
801000c5:	68 a0 ed 10 80       	push   $0x8010eda0
801000ca:	e8 35 50 00 00       	call   80105104 <release>
      acquiresleep(&b->lock);
801000cf:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d2:	89 04 24             	mov    %eax,(%esp)
801000d5:	e8 b4 4d 00 00       	call   80104e8e <acquiresleep>
      return b;
801000da:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000dd:	89 d8                	mov    %ebx,%eax
801000df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e2:	5b                   	pop    %ebx
801000e3:	5e                   	pop    %esi
801000e4:	5f                   	pop    %edi
801000e5:	5d                   	pop    %ebp
801000e6:	c3                   	ret    
  panic("bget: no buffers");
801000e7:	83 ec 0c             	sub    $0xc,%esp
801000ea:	68 80 7b 10 80       	push   $0x80107b80
801000ef:	e8 68 02 00 00       	call   8010035c <panic>

801000f4 <binit>:
{
801000f4:	f3 0f 1e fb          	endbr32 
801000f8:	55                   	push   %ebp
801000f9:	89 e5                	mov    %esp,%ebp
801000fb:	53                   	push   %ebx
801000fc:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000ff:	68 91 7b 10 80       	push   $0x80107b91
80100104:	68 a0 ed 10 80       	push   $0x8010eda0
80100109:	e8 3d 4e 00 00       	call   80104f4b <initlock>
  bcache.head.prev = &bcache.head;
8010010e:	c7 05 ec 34 11 80 9c 	movl   $0x8011349c,0x801134ec
80100115:	34 11 80 
  bcache.head.next = &bcache.head;
80100118:	c7 05 f0 34 11 80 9c 	movl   $0x8011349c,0x801134f0
8010011f:	34 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100122:	83 c4 10             	add    $0x10,%esp
80100125:	bb d4 ed 10 80       	mov    $0x8010edd4,%ebx
8010012a:	eb 37                	jmp    80100163 <binit+0x6f>
    b->next = bcache.head.next;
8010012c:	a1 f0 34 11 80       	mov    0x801134f0,%eax
80100131:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100134:	c7 43 50 9c 34 11 80 	movl   $0x8011349c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010013b:	83 ec 08             	sub    $0x8,%esp
8010013e:	68 98 7b 10 80       	push   $0x80107b98
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	50                   	push   %eax
80100147:	e8 0b 4d 00 00       	call   80104e57 <initsleeplock>
    bcache.head.next->prev = b;
8010014c:	a1 f0 34 11 80       	mov    0x801134f0,%eax
80100151:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100154:	89 1d f0 34 11 80    	mov    %ebx,0x801134f0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010015a:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
80100160:	83 c4 10             	add    $0x10,%esp
80100163:	81 fb 9c 34 11 80    	cmp    $0x8011349c,%ebx
80100169:	72 c1                	jb     8010012c <binit+0x38>
}
8010016b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016e:	c9                   	leave  
8010016f:	c3                   	ret    

80100170 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100170:	f3 0f 1e fb          	endbr32 
80100174:	55                   	push   %ebp
80100175:	89 e5                	mov    %esp,%ebp
80100177:	53                   	push   %ebx
80100178:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
8010017b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010017e:	8b 45 08             	mov    0x8(%ebp),%eax
80100181:	e8 ae fe ff ff       	call   80100034 <bget>
80100186:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100188:	f6 00 02             	testb  $0x2,(%eax)
8010018b:	74 07                	je     80100194 <bread+0x24>
    iderw(b);
  }
  return b;
}
8010018d:	89 d8                	mov    %ebx,%eax
8010018f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100192:	c9                   	leave  
80100193:	c3                   	ret    
    iderw(b);
80100194:	83 ec 0c             	sub    $0xc,%esp
80100197:	50                   	push   %eax
80100198:	e8 9d 1d 00 00       	call   80101f3a <iderw>
8010019d:	83 c4 10             	add    $0x10,%esp
  return b;
801001a0:	eb eb                	jmp    8010018d <bread+0x1d>

801001a2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a2:	f3 0f 1e fb          	endbr32 
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	53                   	push   %ebx
801001aa:	83 ec 10             	sub    $0x10,%esp
801001ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001b0:	8d 43 0c             	lea    0xc(%ebx),%eax
801001b3:	50                   	push   %eax
801001b4:	e8 67 4d 00 00       	call   80104f20 <holdingsleep>
801001b9:	83 c4 10             	add    $0x10,%esp
801001bc:	85 c0                	test   %eax,%eax
801001be:	74 14                	je     801001d4 <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001c0:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001c3:	83 ec 0c             	sub    $0xc,%esp
801001c6:	53                   	push   %ebx
801001c7:	e8 6e 1d 00 00       	call   80101f3a <iderw>
}
801001cc:	83 c4 10             	add    $0x10,%esp
801001cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d2:	c9                   	leave  
801001d3:	c3                   	ret    
    panic("bwrite");
801001d4:	83 ec 0c             	sub    $0xc,%esp
801001d7:	68 9f 7b 10 80       	push   $0x80107b9f
801001dc:	e8 7b 01 00 00       	call   8010035c <panic>

801001e1 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e1:	f3 0f 1e fb          	endbr32 
801001e5:	55                   	push   %ebp
801001e6:	89 e5                	mov    %esp,%ebp
801001e8:	56                   	push   %esi
801001e9:	53                   	push   %ebx
801001ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ed:	8d 73 0c             	lea    0xc(%ebx),%esi
801001f0:	83 ec 0c             	sub    $0xc,%esp
801001f3:	56                   	push   %esi
801001f4:	e8 27 4d 00 00       	call   80104f20 <holdingsleep>
801001f9:	83 c4 10             	add    $0x10,%esp
801001fc:	85 c0                	test   %eax,%eax
801001fe:	74 6b                	je     8010026b <brelse+0x8a>
    panic("brelse");

  releasesleep(&b->lock);
80100200:	83 ec 0c             	sub    $0xc,%esp
80100203:	56                   	push   %esi
80100204:	e8 d8 4c 00 00       	call   80104ee1 <releasesleep>

  acquire(&bcache.lock);
80100209:	c7 04 24 a0 ed 10 80 	movl   $0x8010eda0,(%esp)
80100210:	e8 86 4e 00 00       	call   8010509b <acquire>
  b->refcnt--;
80100215:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100218:	83 e8 01             	sub    $0x1,%eax
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	83 c4 10             	add    $0x10,%esp
80100221:	85 c0                	test   %eax,%eax
80100223:	75 2f                	jne    80100254 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100225:	8b 43 54             	mov    0x54(%ebx),%eax
80100228:	8b 53 50             	mov    0x50(%ebx),%edx
8010022b:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010022e:	8b 43 50             	mov    0x50(%ebx),%eax
80100231:	8b 53 54             	mov    0x54(%ebx),%edx
80100234:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100237:	a1 f0 34 11 80       	mov    0x801134f0,%eax
8010023c:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010023f:	c7 43 50 9c 34 11 80 	movl   $0x8011349c,0x50(%ebx)
    bcache.head.next->prev = b;
80100246:	a1 f0 34 11 80       	mov    0x801134f0,%eax
8010024b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010024e:	89 1d f0 34 11 80    	mov    %ebx,0x801134f0
  }
  
  release(&bcache.lock);
80100254:	83 ec 0c             	sub    $0xc,%esp
80100257:	68 a0 ed 10 80       	push   $0x8010eda0
8010025c:	e8 a3 4e 00 00       	call   80105104 <release>
}
80100261:	83 c4 10             	add    $0x10,%esp
80100264:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100267:	5b                   	pop    %ebx
80100268:	5e                   	pop    %esi
80100269:	5d                   	pop    %ebp
8010026a:	c3                   	ret    
    panic("brelse");
8010026b:	83 ec 0c             	sub    $0xc,%esp
8010026e:	68 a6 7b 10 80       	push   $0x80107ba6
80100273:	e8 e4 00 00 00       	call   8010035c <panic>

80100278 <consoleread>:
#endif
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100278:	f3 0f 1e fb          	endbr32 
8010027c:	55                   	push   %ebp
8010027d:	89 e5                	mov    %esp,%ebp
8010027f:	57                   	push   %edi
80100280:	56                   	push   %esi
80100281:	53                   	push   %ebx
80100282:	83 ec 28             	sub    $0x28,%esp
80100285:	8b 7d 08             	mov    0x8(%ebp),%edi
80100288:	8b 75 0c             	mov    0xc(%ebp),%esi
8010028b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010028e:	57                   	push   %edi
8010028f:	e8 ad 14 00 00       	call   80101741 <iunlock>
  target = n;
80100294:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100297:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010029e:	e8 f8 4d 00 00       	call   8010509b <acquire>
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	85 db                	test   %ebx,%ebx
801002a8:	0f 8e 8f 00 00 00    	jle    8010033d <consoleread+0xc5>
    while(input.r == input.w){
801002ae:	a1 80 37 11 80       	mov    0x80113780,%eax
801002b3:	3b 05 84 37 11 80    	cmp    0x80113784,%eax
801002b9:	75 47                	jne    80100302 <consoleread+0x8a>
      if(myproc()->killed){
801002bb:	e8 c8 35 00 00       	call   80103888 <myproc>
801002c0:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002c4:	75 17                	jne    801002dd <consoleread+0x65>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c6:	83 ec 08             	sub    $0x8,%esp
801002c9:	68 20 b5 10 80       	push   $0x8010b520
801002ce:	68 80 37 11 80       	push   $0x80113780
801002d3:	e8 09 3e 00 00       	call   801040e1 <sleep>
801002d8:	83 c4 10             	add    $0x10,%esp
801002db:	eb d1                	jmp    801002ae <consoleread+0x36>
        release(&cons.lock);
801002dd:	83 ec 0c             	sub    $0xc,%esp
801002e0:	68 20 b5 10 80       	push   $0x8010b520
801002e5:	e8 1a 4e 00 00       	call   80105104 <release>
        ilock(ip);
801002ea:	89 3c 24             	mov    %edi,(%esp)
801002ed:	e8 89 13 00 00       	call   8010167b <ilock>
        return -1;
801002f2:	83 c4 10             	add    $0x10,%esp
801002f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fd:	5b                   	pop    %ebx
801002fe:	5e                   	pop    %esi
801002ff:	5f                   	pop    %edi
80100300:	5d                   	pop    %ebp
80100301:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
80100302:	8d 50 01             	lea    0x1(%eax),%edx
80100305:	89 15 80 37 11 80    	mov    %edx,0x80113780
8010030b:	89 c2                	mov    %eax,%edx
8010030d:	83 e2 7f             	and    $0x7f,%edx
80100310:	0f b6 92 00 37 11 80 	movzbl -0x7feec900(%edx),%edx
80100317:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
8010031a:	80 fa 04             	cmp    $0x4,%dl
8010031d:	74 14                	je     80100333 <consoleread+0xbb>
    *dst++ = c;
8010031f:	8d 46 01             	lea    0x1(%esi),%eax
80100322:	88 16                	mov    %dl,(%esi)
    --n;
80100324:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100327:	83 f9 0a             	cmp    $0xa,%ecx
8010032a:	74 11                	je     8010033d <consoleread+0xc5>
    *dst++ = c;
8010032c:	89 c6                	mov    %eax,%esi
8010032e:	e9 73 ff ff ff       	jmp    801002a6 <consoleread+0x2e>
      if(n < target){
80100333:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100336:	73 05                	jae    8010033d <consoleread+0xc5>
        input.r--;
80100338:	a3 80 37 11 80       	mov    %eax,0x80113780
  release(&cons.lock);
8010033d:	83 ec 0c             	sub    $0xc,%esp
80100340:	68 20 b5 10 80       	push   $0x8010b520
80100345:	e8 ba 4d 00 00       	call   80105104 <release>
  ilock(ip);
8010034a:	89 3c 24             	mov    %edi,(%esp)
8010034d:	e8 29 13 00 00       	call   8010167b <ilock>
  return target - n;
80100352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100355:	29 d8                	sub    %ebx,%eax
80100357:	83 c4 10             	add    $0x10,%esp
8010035a:	eb 9e                	jmp    801002fa <consoleread+0x82>

8010035c <panic>:
{
8010035c:	f3 0f 1e fb          	endbr32 
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	53                   	push   %ebx
80100364:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100367:	fa                   	cli    
  cons.locking = 0;
80100368:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
8010036f:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100372:	e8 53 21 00 00       	call   801024ca <lapicid>
80100377:	83 ec 08             	sub    $0x8,%esp
8010037a:	50                   	push   %eax
8010037b:	68 ad 7b 10 80       	push   $0x80107bad
80100380:	e8 a4 02 00 00       	call   80100629 <cprintf>
  cprintf(s);
80100385:	83 c4 04             	add    $0x4,%esp
80100388:	ff 75 08             	pushl  0x8(%ebp)
8010038b:	e8 99 02 00 00       	call   80100629 <cprintf>
  cprintf("\n");
80100390:	c7 04 24 7b 8c 10 80 	movl   $0x80108c7b,(%esp)
80100397:	e8 8d 02 00 00       	call   80100629 <cprintf>
  getcallerpcs(&s, pcs);
8010039c:	83 c4 08             	add    $0x8,%esp
8010039f:	8d 45 d0             	lea    -0x30(%ebp),%eax
801003a2:	50                   	push   %eax
801003a3:	8d 45 08             	lea    0x8(%ebp),%eax
801003a6:	50                   	push   %eax
801003a7:	e8 be 4b 00 00       	call   80104f6a <getcallerpcs>
  for(i=0; i<10; i++)
801003ac:	83 c4 10             	add    $0x10,%esp
801003af:	bb 00 00 00 00       	mov    $0x0,%ebx
801003b4:	eb 17                	jmp    801003cd <panic+0x71>
    cprintf(" %p", pcs[i]);
801003b6:	83 ec 08             	sub    $0x8,%esp
801003b9:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003bd:	68 c1 7b 10 80       	push   $0x80107bc1
801003c2:	e8 62 02 00 00       	call   80100629 <cprintf>
  for(i=0; i<10; i++)
801003c7:	83 c3 01             	add    $0x1,%ebx
801003ca:	83 c4 10             	add    $0x10,%esp
801003cd:	83 fb 09             	cmp    $0x9,%ebx
801003d0:	7e e4                	jle    801003b6 <panic+0x5a>
  panicked = 1; // freeze other CPU
801003d2:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003d9:	00 00 00 
  for(;;)
801003dc:	eb fe                	jmp    801003dc <panic+0x80>

801003de <cgaputc>:
{
801003de:	55                   	push   %ebp
801003df:	89 e5                	mov    %esp,%ebp
801003e1:	57                   	push   %edi
801003e2:	56                   	push   %esi
801003e3:	53                   	push   %ebx
801003e4:	83 ec 0c             	sub    $0xc,%esp
801003e7:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e9:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801003ee:	b8 0e 00 00 00       	mov    $0xe,%eax
801003f3:	89 ca                	mov    %ecx,%edx
801003f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003fb:	89 da                	mov    %ebx,%edx
801003fd:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003fe:	0f b6 f8             	movzbl %al,%edi
80100401:	c1 e7 08             	shl    $0x8,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100404:	b8 0f 00 00 00       	mov    $0xf,%eax
80100409:	89 ca                	mov    %ecx,%edx
8010040b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010040c:	89 da                	mov    %ebx,%edx
8010040e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010040f:	0f b6 c8             	movzbl %al,%ecx
80100412:	09 f9                	or     %edi,%ecx
  if(c == '\n')
80100414:	83 fe 0a             	cmp    $0xa,%esi
80100417:	74 66                	je     8010047f <cgaputc+0xa1>
  else if(c == BACKSPACE){
80100419:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010041f:	74 7f                	je     801004a0 <cgaputc+0xc2>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100421:	89 f0                	mov    %esi,%eax
80100423:	0f b6 f0             	movzbl %al,%esi
80100426:	8d 59 01             	lea    0x1(%ecx),%ebx
80100429:	66 81 ce 00 07       	or     $0x700,%si
8010042e:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100435:	80 
  if(pos < 0 || pos > 25*80)
80100436:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010043c:	77 6f                	ja     801004ad <cgaputc+0xcf>
  if((pos/80) >= 24){  // Scroll up.
8010043e:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100444:	7f 74                	jg     801004ba <cgaputc+0xdc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100446:	be d4 03 00 00       	mov    $0x3d4,%esi
8010044b:	b8 0e 00 00 00       	mov    $0xe,%eax
80100450:	89 f2                	mov    %esi,%edx
80100452:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100453:	89 d8                	mov    %ebx,%eax
80100455:	c1 f8 08             	sar    $0x8,%eax
80100458:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010045d:	89 ca                	mov    %ecx,%edx
8010045f:	ee                   	out    %al,(%dx)
80100460:	b8 0f 00 00 00       	mov    $0xf,%eax
80100465:	89 f2                	mov    %esi,%edx
80100467:	ee                   	out    %al,(%dx)
80100468:	89 d8                	mov    %ebx,%eax
8010046a:	89 ca                	mov    %ecx,%edx
8010046c:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010046d:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100474:	80 20 07 
}
80100477:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010047a:	5b                   	pop    %ebx
8010047b:	5e                   	pop    %esi
8010047c:	5f                   	pop    %edi
8010047d:	5d                   	pop    %ebp
8010047e:	c3                   	ret    
    pos += 80 - pos%80;
8010047f:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100484:	89 c8                	mov    %ecx,%eax
80100486:	f7 ea                	imul   %edx
80100488:	c1 fa 05             	sar    $0x5,%edx
8010048b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010048e:	c1 e0 04             	shl    $0x4,%eax
80100491:	89 ca                	mov    %ecx,%edx
80100493:	29 c2                	sub    %eax,%edx
80100495:	bb 50 00 00 00       	mov    $0x50,%ebx
8010049a:	29 d3                	sub    %edx,%ebx
8010049c:	01 cb                	add    %ecx,%ebx
8010049e:	eb 96                	jmp    80100436 <cgaputc+0x58>
    if(pos > 0) --pos;
801004a0:	85 c9                	test   %ecx,%ecx
801004a2:	7e 05                	jle    801004a9 <cgaputc+0xcb>
801004a4:	8d 59 ff             	lea    -0x1(%ecx),%ebx
801004a7:	eb 8d                	jmp    80100436 <cgaputc+0x58>
  pos |= inb(CRTPORT+1);
801004a9:	89 cb                	mov    %ecx,%ebx
801004ab:	eb 89                	jmp    80100436 <cgaputc+0x58>
    panic("pos under/overflow");
801004ad:	83 ec 0c             	sub    $0xc,%esp
801004b0:	68 c5 7b 10 80       	push   $0x80107bc5
801004b5:	e8 a2 fe ff ff       	call   8010035c <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004ba:	83 ec 04             	sub    $0x4,%esp
801004bd:	68 60 0e 00 00       	push   $0xe60
801004c2:	68 a0 80 0b 80       	push   $0x800b80a0
801004c7:	68 00 80 0b 80       	push   $0x800b8000
801004cc:	e8 fe 4c 00 00       	call   801051cf <memmove>
    pos -= 80;
801004d1:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004d4:	b8 80 07 00 00       	mov    $0x780,%eax
801004d9:	29 d8                	sub    %ebx,%eax
801004db:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004e2:	83 c4 0c             	add    $0xc,%esp
801004e5:	01 c0                	add    %eax,%eax
801004e7:	50                   	push   %eax
801004e8:	6a 00                	push   $0x0
801004ea:	52                   	push   %edx
801004eb:	e8 5f 4c 00 00       	call   8010514f <memset>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 4e ff ff ff       	jmp    80100446 <cgaputc+0x68>

801004f8 <consputc>:
  if(panicked){
801004f8:	83 3d 58 b5 10 80 00 	cmpl   $0x0,0x8010b558
801004ff:	74 03                	je     80100504 <consputc+0xc>
  asm volatile("cli");
80100501:	fa                   	cli    
    for(;;)
80100502:	eb fe                	jmp    80100502 <consputc+0xa>
{
80100504:	55                   	push   %ebp
80100505:	89 e5                	mov    %esp,%ebp
80100507:	53                   	push   %ebx
80100508:	83 ec 04             	sub    $0x4,%esp
8010050b:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
8010050d:	3d 00 01 00 00       	cmp    $0x100,%eax
80100512:	74 18                	je     8010052c <consputc+0x34>
    uartputc(c);
80100514:	83 ec 0c             	sub    $0xc,%esp
80100517:	50                   	push   %eax
80100518:	e8 24 62 00 00       	call   80106741 <uartputc>
8010051d:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100520:	89 d8                	mov    %ebx,%eax
80100522:	e8 b7 fe ff ff       	call   801003de <cgaputc>
}
80100527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010052a:	c9                   	leave  
8010052b:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010052c:	83 ec 0c             	sub    $0xc,%esp
8010052f:	6a 08                	push   $0x8
80100531:	e8 0b 62 00 00       	call   80106741 <uartputc>
80100536:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010053d:	e8 ff 61 00 00       	call   80106741 <uartputc>
80100542:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100549:	e8 f3 61 00 00       	call   80106741 <uartputc>
8010054e:	83 c4 10             	add    $0x10,%esp
80100551:	eb cd                	jmp    80100520 <consputc+0x28>

80100553 <printint>:
{
80100553:	55                   	push   %ebp
80100554:	89 e5                	mov    %esp,%ebp
80100556:	57                   	push   %edi
80100557:	56                   	push   %esi
80100558:	53                   	push   %ebx
80100559:	83 ec 2c             	sub    $0x2c,%esp
8010055c:	89 d6                	mov    %edx,%esi
8010055e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100561:	85 c9                	test   %ecx,%ecx
80100563:	74 0c                	je     80100571 <printint+0x1e>
80100565:	89 c7                	mov    %eax,%edi
80100567:	c1 ef 1f             	shr    $0x1f,%edi
8010056a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010056d:	85 c0                	test   %eax,%eax
8010056f:	78 38                	js     801005a9 <printint+0x56>
    x = xx;
80100571:	89 c1                	mov    %eax,%ecx
  i = 0;
80100573:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100578:	89 c8                	mov    %ecx,%eax
8010057a:	ba 00 00 00 00       	mov    $0x0,%edx
8010057f:	f7 f6                	div    %esi
80100581:	89 df                	mov    %ebx,%edi
80100583:	83 c3 01             	add    $0x1,%ebx
80100586:	0f b6 92 70 7c 10 80 	movzbl -0x7fef8390(%edx),%edx
8010058d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
80100591:	89 ca                	mov    %ecx,%edx
80100593:	89 c1                	mov    %eax,%ecx
80100595:	39 d6                	cmp    %edx,%esi
80100597:	76 df                	jbe    80100578 <printint+0x25>
  if(sign)
80100599:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010059d:	74 1a                	je     801005b9 <printint+0x66>
    buf[i++] = '-';
8010059f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
801005a4:	8d 5f 02             	lea    0x2(%edi),%ebx
801005a7:	eb 10                	jmp    801005b9 <printint+0x66>
    x = -xx;
801005a9:	f7 d8                	neg    %eax
801005ab:	89 c1                	mov    %eax,%ecx
801005ad:	eb c4                	jmp    80100573 <printint+0x20>
    consputc(buf[i]);
801005af:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
801005b4:	e8 3f ff ff ff       	call   801004f8 <consputc>
  while(--i >= 0)
801005b9:	83 eb 01             	sub    $0x1,%ebx
801005bc:	79 f1                	jns    801005af <printint+0x5c>
}
801005be:	83 c4 2c             	add    $0x2c,%esp
801005c1:	5b                   	pop    %ebx
801005c2:	5e                   	pop    %esi
801005c3:	5f                   	pop    %edi
801005c4:	5d                   	pop    %ebp
801005c5:	c3                   	ret    

801005c6 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005c6:	f3 0f 1e fb          	endbr32 
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	57                   	push   %edi
801005ce:	56                   	push   %esi
801005cf:	53                   	push   %ebx
801005d0:	83 ec 18             	sub    $0x18,%esp
801005d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005d6:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005d9:	ff 75 08             	pushl  0x8(%ebp)
801005dc:	e8 60 11 00 00       	call   80101741 <iunlock>
  acquire(&cons.lock);
801005e1:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801005e8:	e8 ae 4a 00 00       	call   8010509b <acquire>
  for(i = 0; i < n; i++)
801005ed:	83 c4 10             	add    $0x10,%esp
801005f0:	bb 00 00 00 00       	mov    $0x0,%ebx
801005f5:	39 f3                	cmp    %esi,%ebx
801005f7:	7d 0e                	jge    80100607 <consolewrite+0x41>
    consputc(buf[i] & 0xff);
801005f9:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005fd:	e8 f6 fe ff ff       	call   801004f8 <consputc>
  for(i = 0; i < n; i++)
80100602:	83 c3 01             	add    $0x1,%ebx
80100605:	eb ee                	jmp    801005f5 <consolewrite+0x2f>
  release(&cons.lock);
80100607:	83 ec 0c             	sub    $0xc,%esp
8010060a:	68 20 b5 10 80       	push   $0x8010b520
8010060f:	e8 f0 4a 00 00       	call   80105104 <release>
  ilock(ip);
80100614:	83 c4 04             	add    $0x4,%esp
80100617:	ff 75 08             	pushl  0x8(%ebp)
8010061a:	e8 5c 10 00 00       	call   8010167b <ilock>

  return n;
}
8010061f:	89 f0                	mov    %esi,%eax
80100621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100624:	5b                   	pop    %ebx
80100625:	5e                   	pop    %esi
80100626:	5f                   	pop    %edi
80100627:	5d                   	pop    %ebp
80100628:	c3                   	ret    

80100629 <cprintf>:
{
80100629:	f3 0f 1e fb          	endbr32 
8010062d:	55                   	push   %ebp
8010062e:	89 e5                	mov    %esp,%ebp
80100630:	57                   	push   %edi
80100631:	56                   	push   %esi
80100632:	53                   	push   %ebx
80100633:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100636:	a1 54 b5 10 80       	mov    0x8010b554,%eax
8010063b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
8010063e:	85 c0                	test   %eax,%eax
80100640:	75 10                	jne    80100652 <cprintf+0x29>
  if (fmt == 0)
80100642:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100646:	74 1c                	je     80100664 <cprintf+0x3b>
  argp = (uint*)(void*)(&fmt + 1);
80100648:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064b:	be 00 00 00 00       	mov    $0x0,%esi
80100650:	eb 27                	jmp    80100679 <cprintf+0x50>
    acquire(&cons.lock);
80100652:	83 ec 0c             	sub    $0xc,%esp
80100655:	68 20 b5 10 80       	push   $0x8010b520
8010065a:	e8 3c 4a 00 00       	call   8010509b <acquire>
8010065f:	83 c4 10             	add    $0x10,%esp
80100662:	eb de                	jmp    80100642 <cprintf+0x19>
    panic("null fmt");
80100664:	83 ec 0c             	sub    $0xc,%esp
80100667:	68 df 7b 10 80       	push   $0x80107bdf
8010066c:	e8 eb fc ff ff       	call   8010035c <panic>
      consputc(c);
80100671:	e8 82 fe ff ff       	call   801004f8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	83 c6 01             	add    $0x1,%esi
80100679:	8b 55 08             	mov    0x8(%ebp),%edx
8010067c:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
80100680:	85 c0                	test   %eax,%eax
80100682:	0f 84 b1 00 00 00    	je     80100739 <cprintf+0x110>
    if(c != '%'){
80100688:	83 f8 25             	cmp    $0x25,%eax
8010068b:	75 e4                	jne    80100671 <cprintf+0x48>
    c = fmt[++i] & 0xff;
8010068d:	83 c6 01             	add    $0x1,%esi
80100690:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
80100694:	85 db                	test   %ebx,%ebx
80100696:	0f 84 9d 00 00 00    	je     80100739 <cprintf+0x110>
    switch(c){
8010069c:	83 fb 70             	cmp    $0x70,%ebx
8010069f:	74 2e                	je     801006cf <cprintf+0xa6>
801006a1:	7f 22                	jg     801006c5 <cprintf+0x9c>
801006a3:	83 fb 25             	cmp    $0x25,%ebx
801006a6:	74 6c                	je     80100714 <cprintf+0xeb>
801006a8:	83 fb 64             	cmp    $0x64,%ebx
801006ab:	75 76                	jne    80100723 <cprintf+0xfa>
      printint(*argp++, 10, 1);
801006ad:	8d 5f 04             	lea    0x4(%edi),%ebx
801006b0:	8b 07                	mov    (%edi),%eax
801006b2:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b7:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bc:	e8 92 fe ff ff       	call   80100553 <printint>
801006c1:	89 df                	mov    %ebx,%edi
      break;
801006c3:	eb b1                	jmp    80100676 <cprintf+0x4d>
    switch(c){
801006c5:	83 fb 73             	cmp    $0x73,%ebx
801006c8:	74 1d                	je     801006e7 <cprintf+0xbe>
801006ca:	83 fb 78             	cmp    $0x78,%ebx
801006cd:	75 54                	jne    80100723 <cprintf+0xfa>
      printint(*argp++, 16, 0);
801006cf:	8d 5f 04             	lea    0x4(%edi),%ebx
801006d2:	8b 07                	mov    (%edi),%eax
801006d4:	b9 00 00 00 00       	mov    $0x0,%ecx
801006d9:	ba 10 00 00 00       	mov    $0x10,%edx
801006de:	e8 70 fe ff ff       	call   80100553 <printint>
801006e3:	89 df                	mov    %ebx,%edi
      break;
801006e5:	eb 8f                	jmp    80100676 <cprintf+0x4d>
      if((s = (char*)*argp++) == 0)
801006e7:	8d 47 04             	lea    0x4(%edi),%eax
801006ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006ed:	8b 1f                	mov    (%edi),%ebx
801006ef:	85 db                	test   %ebx,%ebx
801006f1:	75 05                	jne    801006f8 <cprintf+0xcf>
        s = "(null)";
801006f3:	bb d8 7b 10 80       	mov    $0x80107bd8,%ebx
      for(; *s; s++)
801006f8:	0f b6 03             	movzbl (%ebx),%eax
801006fb:	84 c0                	test   %al,%al
801006fd:	74 0d                	je     8010070c <cprintf+0xe3>
        consputc(*s);
801006ff:	0f be c0             	movsbl %al,%eax
80100702:	e8 f1 fd ff ff       	call   801004f8 <consputc>
      for(; *s; s++)
80100707:	83 c3 01             	add    $0x1,%ebx
8010070a:	eb ec                	jmp    801006f8 <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
8010070c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010070f:	e9 62 ff ff ff       	jmp    80100676 <cprintf+0x4d>
      consputc('%');
80100714:	b8 25 00 00 00       	mov    $0x25,%eax
80100719:	e8 da fd ff ff       	call   801004f8 <consputc>
      break;
8010071e:	e9 53 ff ff ff       	jmp    80100676 <cprintf+0x4d>
      consputc('%');
80100723:	b8 25 00 00 00       	mov    $0x25,%eax
80100728:	e8 cb fd ff ff       	call   801004f8 <consputc>
      consputc(c);
8010072d:	89 d8                	mov    %ebx,%eax
8010072f:	e8 c4 fd ff ff       	call   801004f8 <consputc>
      break;
80100734:	e9 3d ff ff ff       	jmp    80100676 <cprintf+0x4d>
  if(locking)
80100739:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010073d:	75 08                	jne    80100747 <cprintf+0x11e>
}
8010073f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100742:	5b                   	pop    %ebx
80100743:	5e                   	pop    %esi
80100744:	5f                   	pop    %edi
80100745:	5d                   	pop    %ebp
80100746:	c3                   	ret    
    release(&cons.lock);
80100747:	83 ec 0c             	sub    $0xc,%esp
8010074a:	68 20 b5 10 80       	push   $0x8010b520
8010074f:	e8 b0 49 00 00       	call   80105104 <release>
80100754:	83 c4 10             	add    $0x10,%esp
}
80100757:	eb e6                	jmp    8010073f <cprintf+0x116>

80100759 <do_shutdown>:
{
80100759:	f3 0f 1e fb          	endbr32 
8010075d:	55                   	push   %ebp
8010075e:	89 e5                	mov    %esp,%ebp
80100760:	83 ec 14             	sub    $0x14,%esp
  cprintf("\nShutting down ...\n");
80100763:	68 e8 7b 10 80       	push   $0x80107be8
80100768:	e8 bc fe ff ff       	call   80100629 <cprintf>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010076d:	b8 00 20 00 00       	mov    $0x2000,%eax
80100772:	ba 04 06 00 00       	mov    $0x604,%edx
80100777:	66 ef                	out    %ax,(%dx)
  return;  // not reached
80100779:	83 c4 10             	add    $0x10,%esp
}
8010077c:	c9                   	leave  
8010077d:	c3                   	ret    

8010077e <consoleintr>:
{
8010077e:	f3 0f 1e fb          	endbr32 
80100782:	55                   	push   %ebp
80100783:	89 e5                	mov    %esp,%ebp
80100785:	57                   	push   %edi
80100786:	56                   	push   %esi
80100787:	53                   	push   %ebx
80100788:	83 ec 28             	sub    $0x28,%esp
8010078b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010078e:	68 20 b5 10 80       	push   $0x8010b520
80100793:	e8 03 49 00 00       	call   8010509b <acquire>
  while((c = getc()) >= 0){
80100798:	83 c4 10             	add    $0x10,%esp
  int shutdown = FALSE;
8010079b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    int doCtl = -1;
801007a2:	be ff ff ff ff       	mov    $0xffffffff,%esi
  int c, doprocdump = 0;
801007a7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((c = getc()) >= 0){
801007ae:	ff d7                	call   *%edi
801007b0:	89 c3                	mov    %eax,%ebx
801007b2:	85 c0                	test   %eax,%eax
801007b4:	0f 88 54 01 00 00    	js     8010090e <consoleintr+0x190>
    switch(c){
801007ba:	83 fb 1a             	cmp    $0x1a,%ebx
801007bd:	7f 1b                	jg     801007da <consoleintr+0x5c>
801007bf:	83 fb 02             	cmp    $0x2,%ebx
801007c2:	7c 1f                	jl     801007e3 <consoleintr+0x65>
801007c4:	83 fb 1a             	cmp    $0x1a,%ebx
801007c7:	77 1a                	ja     801007e3 <consoleintr+0x65>
801007c9:	3e ff 24 9d 04 7c 10 	notrack jmp *-0x7fef83fc(,%ebx,4)
801007d0:	80 
801007d1:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
801007d8:	eb d4                	jmp    801007ae <consoleintr+0x30>
801007da:	83 fb 7f             	cmp    $0x7f,%ebx
801007dd:	0f 84 e3 00 00 00    	je     801008c6 <consoleintr+0x148>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007e3:	85 db                	test   %ebx,%ebx
801007e5:	74 c7                	je     801007ae <consoleintr+0x30>
801007e7:	a1 88 37 11 80       	mov    0x80113788,%eax
801007ec:	89 c2                	mov    %eax,%edx
801007ee:	2b 15 80 37 11 80    	sub    0x80113780,%edx
801007f4:	83 fa 7f             	cmp    $0x7f,%edx
801007f7:	77 b5                	ja     801007ae <consoleintr+0x30>
        c = (c == '\r') ? '\n' : c;
801007f9:	83 fb 0d             	cmp    $0xd,%ebx
801007fc:	0f 84 f8 00 00 00    	je     801008fa <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100802:	8d 50 01             	lea    0x1(%eax),%edx
80100805:	89 15 88 37 11 80    	mov    %edx,0x80113788
8010080b:	83 e0 7f             	and    $0x7f,%eax
8010080e:	88 98 00 37 11 80    	mov    %bl,-0x7feec900(%eax)
        consputc(c);
80100814:	89 d8                	mov    %ebx,%eax
80100816:	e8 dd fc ff ff       	call   801004f8 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010081b:	83 fb 0a             	cmp    $0xa,%ebx
8010081e:	0f 94 c2             	sete   %dl
80100821:	83 fb 04             	cmp    $0x4,%ebx
80100824:	0f 94 c0             	sete   %al
80100827:	08 c2                	or     %al,%dl
80100829:	75 14                	jne    8010083f <consoleintr+0xc1>
8010082b:	a1 80 37 11 80       	mov    0x80113780,%eax
80100830:	83 e8 80             	sub    $0xffffff80,%eax
80100833:	39 05 88 37 11 80    	cmp    %eax,0x80113788
80100839:	0f 85 6f ff ff ff    	jne    801007ae <consoleintr+0x30>
          input.w = input.e;
8010083f:	a1 88 37 11 80       	mov    0x80113788,%eax
80100844:	a3 84 37 11 80       	mov    %eax,0x80113784
          wakeup(&input.r);
80100849:	83 ec 0c             	sub    $0xc,%esp
8010084c:	68 80 37 11 80       	push   $0x80113780
80100851:	e8 8a 3b 00 00       	call   801043e0 <wakeup>
80100856:	83 c4 10             	add    $0x10,%esp
80100859:	e9 50 ff ff ff       	jmp    801007ae <consoleintr+0x30>
      doCtl = UNUSED;
8010085e:	be 00 00 00 00       	mov    $0x0,%esi
      break;
80100863:	e9 46 ff ff ff       	jmp    801007ae <consoleintr+0x30>
      doCtl = SLEEPING;
80100868:	be 02 00 00 00       	mov    $0x2,%esi
      break;
8010086d:	e9 3c ff ff ff       	jmp    801007ae <consoleintr+0x30>
      doCtl = ZOMBIE;
80100872:	be 05 00 00 00       	mov    $0x5,%esi
      break;
80100877:	e9 32 ff ff ff       	jmp    801007ae <consoleintr+0x30>
      doCtl = RUNNING;
8010087c:	be 04 00 00 00       	mov    $0x4,%esi
      break;
80100881:	e9 28 ff ff ff       	jmp    801007ae <consoleintr+0x30>
      doCtl = 100;  // print list stats
80100886:	be 64 00 00 00       	mov    $0x64,%esi
      break;
8010088b:	e9 1e ff ff ff       	jmp    801007ae <consoleintr+0x30>
        input.e--;
80100890:	a3 88 37 11 80       	mov    %eax,0x80113788
        consputc(BACKSPACE);
80100895:	b8 00 01 00 00       	mov    $0x100,%eax
8010089a:	e8 59 fc ff ff       	call   801004f8 <consputc>
      while(input.e != input.w &&
8010089f:	a1 88 37 11 80       	mov    0x80113788,%eax
801008a4:	3b 05 84 37 11 80    	cmp    0x80113784,%eax
801008aa:	0f 84 fe fe ff ff    	je     801007ae <consoleintr+0x30>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008b0:	83 e8 01             	sub    $0x1,%eax
801008b3:	89 c2                	mov    %eax,%edx
801008b5:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008b8:	80 ba 00 37 11 80 0a 	cmpb   $0xa,-0x7feec900(%edx)
801008bf:	75 cf                	jne    80100890 <consoleintr+0x112>
801008c1:	e9 e8 fe ff ff       	jmp    801007ae <consoleintr+0x30>
      if(input.e != input.w){
801008c6:	a1 88 37 11 80       	mov    0x80113788,%eax
801008cb:	3b 05 84 37 11 80    	cmp    0x80113784,%eax
801008d1:	0f 84 d7 fe ff ff    	je     801007ae <consoleintr+0x30>
        input.e--;
801008d7:	83 e8 01             	sub    $0x1,%eax
801008da:	a3 88 37 11 80       	mov    %eax,0x80113788
        consputc(BACKSPACE);
801008df:	b8 00 01 00 00       	mov    $0x100,%eax
801008e4:	e8 0f fc ff ff       	call   801004f8 <consputc>
801008e9:	e9 c0 fe ff ff       	jmp    801007ae <consoleintr+0x30>
      shutdown = TRUE;
801008ee:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
      break;
801008f5:	e9 b4 fe ff ff       	jmp    801007ae <consoleintr+0x30>
        c = (c == '\r') ? '\n' : c;
801008fa:	bb 0a 00 00 00       	mov    $0xa,%ebx
801008ff:	e9 fe fe ff ff       	jmp    80100802 <consoleintr+0x84>
      doCtl = RUNNABLE;
80100904:	be 03 00 00 00       	mov    $0x3,%esi
80100909:	e9 a0 fe ff ff       	jmp    801007ae <consoleintr+0x30>
  release(&cons.lock);
8010090e:	83 ec 0c             	sub    $0xc,%esp
80100911:	68 20 b5 10 80       	push   $0x8010b520
80100916:	e8 e9 47 00 00       	call   80105104 <release>
  if (shutdown)
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100922:	75 21                	jne    80100945 <consoleintr+0x1c7>
  if(doprocdump) {
80100924:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100928:	75 22                	jne    8010094c <consoleintr+0x1ce>
  if (doCtl == UNUSED) printFreeList();
8010092a:	85 f6                	test   %esi,%esi
8010092c:	74 25                	je     80100953 <consoleintr+0x1d5>
  else if (doCtl == 100) printListStats();
8010092e:	83 fe 64             	cmp    $0x64,%esi
80100931:	74 2d                	je     80100960 <consoleintr+0x1e2>
  else if (doCtl > UNUSED) printList(doCtl);
80100933:	85 f6                	test   %esi,%esi
80100935:	7e 21                	jle    80100958 <consoleintr+0x1da>
80100937:	83 ec 0c             	sub    $0xc,%esp
8010093a:	56                   	push   %esi
8010093b:	e8 e8 3d 00 00       	call   80104728 <printList>
80100940:	83 c4 10             	add    $0x10,%esp
}
80100943:	eb 13                	jmp    80100958 <consoleintr+0x1da>
    do_shutdown();
80100945:	e8 0f fe ff ff       	call   80100759 <do_shutdown>
8010094a:	eb d8                	jmp    80100924 <consoleintr+0x1a6>
    procdump();  // now call procdump() wo. cons.lock held
8010094c:	e8 09 3d 00 00       	call   8010465a <procdump>
80100951:	eb d7                	jmp    8010092a <consoleintr+0x1ac>
  if (doCtl == UNUSED) printFreeList();
80100953:	e8 5e 3f 00 00       	call   801048b6 <printFreeList>
}
80100958:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010095b:	5b                   	pop    %ebx
8010095c:	5e                   	pop    %esi
8010095d:	5f                   	pop    %edi
8010095e:	5d                   	pop    %ebp
8010095f:	c3                   	ret    
  else if (doCtl == 100) printListStats();
80100960:	e8 b1 3f 00 00       	call   80104916 <printListStats>
80100965:	eb f1                	jmp    80100958 <consoleintr+0x1da>

80100967 <consoleinit>:

void
consoleinit(void)
{
80100967:	f3 0f 1e fb          	endbr32 
8010096b:	55                   	push   %ebp
8010096c:	89 e5                	mov    %esp,%ebp
8010096e:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100971:	68 fc 7b 10 80       	push   $0x80107bfc
80100976:	68 20 b5 10 80       	push   $0x8010b520
8010097b:	e8 cb 45 00 00       	call   80104f4b <initlock>

  devsw[CONSOLE].write = consolewrite;
80100980:	c7 05 4c 41 11 80 c6 	movl   $0x801005c6,0x8011414c
80100987:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010098a:	c7 05 48 41 11 80 78 	movl   $0x80100278,0x80114148
80100991:	02 10 80 
  cons.locking = 1;
80100994:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
8010099b:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
8010099e:	83 c4 08             	add    $0x8,%esp
801009a1:	6a 00                	push   $0x0
801009a3:	6a 01                	push   $0x1
801009a5:	e8 02 17 00 00       	call   801020ac <ioapicenable>
}
801009aa:	83 c4 10             	add    $0x10,%esp
801009ad:	c9                   	leave  
801009ae:	c3                   	ret    

801009af <exec>:
#include "elf.h"


int
exec(char *path, char **argv)
{
801009af:	f3 0f 1e fb          	endbr32 
801009b3:	55                   	push   %ebp
801009b4:	89 e5                	mov    %esp,%ebp
801009b6:	57                   	push   %edi
801009b7:	56                   	push   %esi
801009b8:	53                   	push   %ebx
801009b9:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009bf:	e8 c4 2e 00 00       	call   80103888 <myproc>
801009c4:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801009ca:	e8 31 1f 00 00       	call   80102900 <begin_op>

  if((ip = namei(path)) == 0){
801009cf:	83 ec 0c             	sub    $0xc,%esp
801009d2:	ff 75 08             	pushl  0x8(%ebp)
801009d5:	e8 26 13 00 00       	call   80101d00 <namei>
801009da:	83 c4 10             	add    $0x10,%esp
801009dd:	85 c0                	test   %eax,%eax
801009df:	74 56                	je     80100a37 <exec+0x88>
801009e1:	89 c3                	mov    %eax,%ebx
#ifndef PDX_XV6
    cprintf("exec: fail\n");
#endif
    return -1;
  }
  ilock(ip);
801009e3:	83 ec 0c             	sub    $0xc,%esp
801009e6:	50                   	push   %eax
801009e7:	e8 8f 0c 00 00       	call   8010167b <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009ec:	6a 34                	push   $0x34
801009ee:	6a 00                	push   $0x0
801009f0:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009f6:	50                   	push   %eax
801009f7:	53                   	push   %ebx
801009f8:	e8 84 0e 00 00       	call   80101881 <readi>
801009fd:	83 c4 20             	add    $0x20,%esp
80100a00:	83 f8 34             	cmp    $0x34,%eax
80100a03:	75 0c                	jne    80100a11 <exec+0x62>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a05:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a0c:	45 4c 46 
80100a0f:	74 32                	je     80100a43 <exec+0x94>
  return 0;

bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
80100a11:	85 db                	test   %ebx,%ebx
80100a13:	0f 84 b9 02 00 00    	je     80100cd2 <exec+0x323>
    iunlockput(ip);
80100a19:	83 ec 0c             	sub    $0xc,%esp
80100a1c:	53                   	push   %ebx
80100a1d:	e8 0c 0e 00 00       	call   8010182e <iunlockput>
    end_op();
80100a22:	e8 57 1f 00 00       	call   8010297e <end_op>
80100a27:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a32:	5b                   	pop    %ebx
80100a33:	5e                   	pop    %esi
80100a34:	5f                   	pop    %edi
80100a35:	5d                   	pop    %ebp
80100a36:	c3                   	ret    
    end_op();
80100a37:	e8 42 1f 00 00       	call   8010297e <end_op>
    return -1;
80100a3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a41:	eb ec                	jmp    80100a2f <exec+0x80>
  if((pgdir = setupkvm()) == 0)
80100a43:	e8 db 6e 00 00       	call   80107923 <setupkvm>
80100a48:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	0f 84 09 01 00 00    	je     80100b5f <exec+0x1b0>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a56:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
80100a5c:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a61:	be 00 00 00 00       	mov    $0x0,%esi
80100a66:	eb 0c                	jmp    80100a74 <exec+0xc5>
80100a68:	83 c6 01             	add    $0x1,%esi
80100a6b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100a71:	83 c0 20             	add    $0x20,%eax
80100a74:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100a7b:	39 f2                	cmp    %esi,%edx
80100a7d:	0f 8e 98 00 00 00    	jle    80100b1b <exec+0x16c>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a83:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a89:	6a 20                	push   $0x20
80100a8b:	50                   	push   %eax
80100a8c:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a92:	50                   	push   %eax
80100a93:	53                   	push   %ebx
80100a94:	e8 e8 0d 00 00       	call   80101881 <readi>
80100a99:	83 c4 10             	add    $0x10,%esp
80100a9c:	83 f8 20             	cmp    $0x20,%eax
80100a9f:	0f 85 ba 00 00 00    	jne    80100b5f <exec+0x1b0>
    if(ph.type != ELF_PROG_LOAD)
80100aa5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aac:	75 ba                	jne    80100a68 <exec+0xb9>
    if(ph.memsz < ph.filesz)
80100aae:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ab4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aba:	0f 82 9f 00 00 00    	jb     80100b5f <exec+0x1b0>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ac0:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ac6:	0f 82 93 00 00 00    	jb     80100b5f <exec+0x1b0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100acc:	83 ec 04             	sub    $0x4,%esp
80100acf:	50                   	push   %eax
80100ad0:	57                   	push   %edi
80100ad1:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ad7:	e8 e6 6c 00 00       	call   801077c2 <allocuvm>
80100adc:	89 c7                	mov    %eax,%edi
80100ade:	83 c4 10             	add    $0x10,%esp
80100ae1:	85 c0                	test   %eax,%eax
80100ae3:	74 7a                	je     80100b5f <exec+0x1b0>
    if(ph.vaddr % PGSIZE != 0)
80100ae5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100aeb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100af0:	75 6d                	jne    80100b5f <exec+0x1b0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100af2:	83 ec 0c             	sub    $0xc,%esp
80100af5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100afb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b01:	53                   	push   %ebx
80100b02:	50                   	push   %eax
80100b03:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b09:	e8 7f 6b 00 00       	call   8010768d <loaduvm>
80100b0e:	83 c4 20             	add    $0x20,%esp
80100b11:	85 c0                	test   %eax,%eax
80100b13:	0f 89 4f ff ff ff    	jns    80100a68 <exec+0xb9>
80100b19:	eb 44                	jmp    80100b5f <exec+0x1b0>
  iunlockput(ip);
80100b1b:	83 ec 0c             	sub    $0xc,%esp
80100b1e:	53                   	push   %ebx
80100b1f:	e8 0a 0d 00 00       	call   8010182e <iunlockput>
  end_op();
80100b24:	e8 55 1e 00 00       	call   8010297e <end_op>
  sz = PGROUNDUP(sz);
80100b29:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80100b2f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b34:	83 c4 0c             	add    $0xc,%esp
80100b37:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b3d:	52                   	push   %edx
80100b3e:	50                   	push   %eax
80100b3f:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100b45:	57                   	push   %edi
80100b46:	e8 77 6c 00 00       	call   801077c2 <allocuvm>
80100b4b:	89 c6                	mov    %eax,%esi
80100b4d:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b53:	83 c4 10             	add    $0x10,%esp
80100b56:	85 c0                	test   %eax,%eax
80100b58:	75 24                	jne    80100b7e <exec+0x1cf>
  ip = 0;
80100b5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	85 c0                	test   %eax,%eax
80100b67:	0f 84 a4 fe ff ff    	je     80100a11 <exec+0x62>
    freevm(pgdir);
80100b6d:	83 ec 0c             	sub    $0xc,%esp
80100b70:	50                   	push   %eax
80100b71:	e8 39 6d 00 00       	call   801078af <freevm>
80100b76:	83 c4 10             	add    $0x10,%esp
80100b79:	e9 93 fe ff ff       	jmp    80100a11 <exec+0x62>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100b7e:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100b84:	83 ec 08             	sub    $0x8,%esp
80100b87:	50                   	push   %eax
80100b88:	57                   	push   %edi
80100b89:	e8 22 6e 00 00       	call   801079b0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100b8e:	83 c4 10             	add    $0x10,%esp
80100b91:	bf 00 00 00 00       	mov    $0x0,%edi
80100b96:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b99:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100b9c:	8b 03                	mov    (%ebx),%eax
80100b9e:	85 c0                	test   %eax,%eax
80100ba0:	74 4d                	je     80100bef <exec+0x240>
    if(argc >= MAXARG)
80100ba2:	83 ff 1f             	cmp    $0x1f,%edi
80100ba5:	0f 87 13 01 00 00    	ja     80100cbe <exec+0x30f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bab:	83 ec 0c             	sub    $0xc,%esp
80100bae:	50                   	push   %eax
80100baf:	e8 5c 47 00 00       	call   80105310 <strlen>
80100bb4:	29 c6                	sub    %eax,%esi
80100bb6:	83 ee 01             	sub    $0x1,%esi
80100bb9:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bbc:	83 c4 04             	add    $0x4,%esp
80100bbf:	ff 33                	pushl  (%ebx)
80100bc1:	e8 4a 47 00 00       	call   80105310 <strlen>
80100bc6:	83 c0 01             	add    $0x1,%eax
80100bc9:	50                   	push   %eax
80100bca:	ff 33                	pushl  (%ebx)
80100bcc:	56                   	push   %esi
80100bcd:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bd3:	e8 26 6f 00 00       	call   80107afe <copyout>
80100bd8:	83 c4 20             	add    $0x20,%esp
80100bdb:	85 c0                	test   %eax,%eax
80100bdd:	0f 88 e5 00 00 00    	js     80100cc8 <exec+0x319>
    ustack[3+argc] = sp;
80100be3:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100bea:	83 c7 01             	add    $0x1,%edi
80100bed:	eb a7                	jmp    80100b96 <exec+0x1e7>
80100bef:	89 f1                	mov    %esi,%ecx
80100bf1:	89 c3                	mov    %eax,%ebx
  ustack[3+argc] = 0;
80100bf3:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100bfa:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100bfe:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c05:	ff ff ff 
  ustack[1] = argc;
80100c08:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c0e:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c15:	89 f2                	mov    %esi,%edx
80100c17:	29 c2                	sub    %eax,%edx
80100c19:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100c1f:	8d 04 bd 10 00 00 00 	lea    0x10(,%edi,4),%eax
80100c26:	29 c1                	sub    %eax,%ecx
80100c28:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c2a:	50                   	push   %eax
80100c2b:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100c31:	50                   	push   %eax
80100c32:	51                   	push   %ecx
80100c33:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c39:	e8 c0 6e 00 00       	call   80107afe <copyout>
80100c3e:	83 c4 10             	add    $0x10,%esp
80100c41:	85 c0                	test   %eax,%eax
80100c43:	0f 88 16 ff ff ff    	js     80100b5f <exec+0x1b0>
  for(last=s=path; *s; s++)
80100c49:	8b 55 08             	mov    0x8(%ebp),%edx
80100c4c:	89 d0                	mov    %edx,%eax
80100c4e:	eb 03                	jmp    80100c53 <exec+0x2a4>
80100c50:	83 c0 01             	add    $0x1,%eax
80100c53:	0f b6 08             	movzbl (%eax),%ecx
80100c56:	84 c9                	test   %cl,%cl
80100c58:	74 0a                	je     80100c64 <exec+0x2b5>
    if(*s == '/')
80100c5a:	80 f9 2f             	cmp    $0x2f,%cl
80100c5d:	75 f1                	jne    80100c50 <exec+0x2a1>
      last = s+1;
80100c5f:	8d 50 01             	lea    0x1(%eax),%edx
80100c62:	eb ec                	jmp    80100c50 <exec+0x2a1>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100c64:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100c6a:	89 f8                	mov    %edi,%eax
80100c6c:	83 c0 6c             	add    $0x6c,%eax
80100c6f:	83 ec 04             	sub    $0x4,%esp
80100c72:	6a 10                	push   $0x10
80100c74:	52                   	push   %edx
80100c75:	50                   	push   %eax
80100c76:	e8 54 46 00 00       	call   801052cf <safestrcpy>
  oldpgdir = curproc->pgdir;
80100c7b:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100c7e:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100c84:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100c87:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100c8d:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100c8f:	8b 47 18             	mov    0x18(%edi),%eax
80100c92:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c98:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c9b:	8b 47 18             	mov    0x18(%edi),%eax
80100c9e:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100ca1:	89 3c 24             	mov    %edi,(%esp)
80100ca4:	e8 5b 68 00 00       	call   80107504 <switchuvm>
  freevm(oldpgdir);
80100ca9:	89 1c 24             	mov    %ebx,(%esp)
80100cac:	e8 fe 6b 00 00       	call   801078af <freevm>
  return 0;
80100cb1:	83 c4 10             	add    $0x10,%esp
80100cb4:	b8 00 00 00 00       	mov    $0x0,%eax
80100cb9:	e9 71 fd ff ff       	jmp    80100a2f <exec+0x80>
  ip = 0;
80100cbe:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cc3:	e9 97 fe ff ff       	jmp    80100b5f <exec+0x1b0>
80100cc8:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ccd:	e9 8d fe ff ff       	jmp    80100b5f <exec+0x1b0>
  return -1;
80100cd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cd7:	e9 53 fd ff ff       	jmp    80100a2f <exec+0x80>

80100cdc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100cdc:	f3 0f 1e fb          	endbr32 
80100ce0:	55                   	push   %ebp
80100ce1:	89 e5                	mov    %esp,%ebp
80100ce3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100ce6:	68 81 7c 10 80       	push   $0x80107c81
80100ceb:	68 a0 37 11 80       	push   $0x801137a0
80100cf0:	e8 56 42 00 00       	call   80104f4b <initlock>
}
80100cf5:	83 c4 10             	add    $0x10,%esp
80100cf8:	c9                   	leave  
80100cf9:	c3                   	ret    

80100cfa <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100cfa:	f3 0f 1e fb          	endbr32 
80100cfe:	55                   	push   %ebp
80100cff:	89 e5                	mov    %esp,%ebp
80100d01:	53                   	push   %ebx
80100d02:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d05:	68 a0 37 11 80       	push   $0x801137a0
80100d0a:	e8 8c 43 00 00       	call   8010509b <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d0f:	83 c4 10             	add    $0x10,%esp
80100d12:	bb d4 37 11 80       	mov    $0x801137d4,%ebx
80100d17:	eb 03                	jmp    80100d1c <filealloc+0x22>
80100d19:	83 c3 18             	add    $0x18,%ebx
80100d1c:	81 fb 34 41 11 80    	cmp    $0x80114134,%ebx
80100d22:	73 24                	jae    80100d48 <filealloc+0x4e>
    if(f->ref == 0){
80100d24:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100d28:	75 ef                	jne    80100d19 <filealloc+0x1f>
      f->ref = 1;
80100d2a:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d31:	83 ec 0c             	sub    $0xc,%esp
80100d34:	68 a0 37 11 80       	push   $0x801137a0
80100d39:	e8 c6 43 00 00       	call   80105104 <release>
      return f;
80100d3e:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d41:	89 d8                	mov    %ebx,%eax
80100d43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d46:	c9                   	leave  
80100d47:	c3                   	ret    
  release(&ftable.lock);
80100d48:	83 ec 0c             	sub    $0xc,%esp
80100d4b:	68 a0 37 11 80       	push   $0x801137a0
80100d50:	e8 af 43 00 00       	call   80105104 <release>
  return 0;
80100d55:	83 c4 10             	add    $0x10,%esp
80100d58:	bb 00 00 00 00       	mov    $0x0,%ebx
80100d5d:	eb e2                	jmp    80100d41 <filealloc+0x47>

80100d5f <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100d5f:	f3 0f 1e fb          	endbr32 
80100d63:	55                   	push   %ebp
80100d64:	89 e5                	mov    %esp,%ebp
80100d66:	53                   	push   %ebx
80100d67:	83 ec 10             	sub    $0x10,%esp
80100d6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100d6d:	68 a0 37 11 80       	push   $0x801137a0
80100d72:	e8 24 43 00 00       	call   8010509b <acquire>
  if(f->ref < 1)
80100d77:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7a:	83 c4 10             	add    $0x10,%esp
80100d7d:	85 c0                	test   %eax,%eax
80100d7f:	7e 1a                	jle    80100d9b <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100d81:	83 c0 01             	add    $0x1,%eax
80100d84:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d87:	83 ec 0c             	sub    $0xc,%esp
80100d8a:	68 a0 37 11 80       	push   $0x801137a0
80100d8f:	e8 70 43 00 00       	call   80105104 <release>
  return f;
}
80100d94:	89 d8                	mov    %ebx,%eax
80100d96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d99:	c9                   	leave  
80100d9a:	c3                   	ret    
    panic("filedup");
80100d9b:	83 ec 0c             	sub    $0xc,%esp
80100d9e:	68 88 7c 10 80       	push   $0x80107c88
80100da3:	e8 b4 f5 ff ff       	call   8010035c <panic>

80100da8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100da8:	f3 0f 1e fb          	endbr32 
80100dac:	55                   	push   %ebp
80100dad:	89 e5                	mov    %esp,%ebp
80100daf:	53                   	push   %ebx
80100db0:	83 ec 30             	sub    $0x30,%esp
80100db3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100db6:	68 a0 37 11 80       	push   $0x801137a0
80100dbb:	e8 db 42 00 00       	call   8010509b <acquire>
  if(f->ref < 1)
80100dc0:	8b 43 04             	mov    0x4(%ebx),%eax
80100dc3:	83 c4 10             	add    $0x10,%esp
80100dc6:	85 c0                	test   %eax,%eax
80100dc8:	7e 65                	jle    80100e2f <fileclose+0x87>
    panic("fileclose");
  if(--f->ref > 0){
80100dca:	83 e8 01             	sub    $0x1,%eax
80100dcd:	89 43 04             	mov    %eax,0x4(%ebx)
80100dd0:	85 c0                	test   %eax,%eax
80100dd2:	7f 68                	jg     80100e3c <fileclose+0x94>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100dd4:	8b 03                	mov    (%ebx),%eax
80100dd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100dd9:	8b 43 08             	mov    0x8(%ebx),%eax
80100ddc:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ddf:	8b 43 0c             	mov    0xc(%ebx),%eax
80100de2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100de5:	8b 43 10             	mov    0x10(%ebx),%eax
80100de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  f->ref = 0;
80100deb:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100df2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100df8:	83 ec 0c             	sub    $0xc,%esp
80100dfb:	68 a0 37 11 80       	push   $0x801137a0
80100e00:	e8 ff 42 00 00       	call   80105104 <release>

  if(ff.type == FD_PIPE)
80100e05:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e08:	83 c4 10             	add    $0x10,%esp
80100e0b:	83 f8 01             	cmp    $0x1,%eax
80100e0e:	74 41                	je     80100e51 <fileclose+0xa9>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e10:	83 f8 02             	cmp    $0x2,%eax
80100e13:	75 37                	jne    80100e4c <fileclose+0xa4>
    begin_op();
80100e15:	e8 e6 1a 00 00       	call   80102900 <begin_op>
    iput(ff.ip);
80100e1a:	83 ec 0c             	sub    $0xc,%esp
80100e1d:	ff 75 f0             	pushl  -0x10(%ebp)
80100e20:	e8 65 09 00 00       	call   8010178a <iput>
    end_op();
80100e25:	e8 54 1b 00 00       	call   8010297e <end_op>
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	eb 1d                	jmp    80100e4c <fileclose+0xa4>
    panic("fileclose");
80100e2f:	83 ec 0c             	sub    $0xc,%esp
80100e32:	68 90 7c 10 80       	push   $0x80107c90
80100e37:	e8 20 f5 ff ff       	call   8010035c <panic>
    release(&ftable.lock);
80100e3c:	83 ec 0c             	sub    $0xc,%esp
80100e3f:	68 a0 37 11 80       	push   $0x801137a0
80100e44:	e8 bb 42 00 00       	call   80105104 <release>
    return;
80100e49:	83 c4 10             	add    $0x10,%esp
  }
}
80100e4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4f:	c9                   	leave  
80100e50:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100e51:	83 ec 08             	sub    $0x8,%esp
80100e54:	0f be 45 e9          	movsbl -0x17(%ebp),%eax
80100e58:	50                   	push   %eax
80100e59:	ff 75 ec             	pushl  -0x14(%ebp)
80100e5c:	e8 32 21 00 00       	call   80102f93 <pipeclose>
80100e61:	83 c4 10             	add    $0x10,%esp
80100e64:	eb e6                	jmp    80100e4c <fileclose+0xa4>

80100e66 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100e66:	f3 0f 1e fb          	endbr32 
80100e6a:	55                   	push   %ebp
80100e6b:	89 e5                	mov    %esp,%ebp
80100e6d:	53                   	push   %ebx
80100e6e:	83 ec 04             	sub    $0x4,%esp
80100e71:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100e74:	83 3b 02             	cmpl   $0x2,(%ebx)
80100e77:	75 31                	jne    80100eaa <filestat+0x44>
    ilock(f->ip);
80100e79:	83 ec 0c             	sub    $0xc,%esp
80100e7c:	ff 73 10             	pushl  0x10(%ebx)
80100e7f:	e8 f7 07 00 00       	call   8010167b <ilock>
    stati(f->ip, st);
80100e84:	83 c4 08             	add    $0x8,%esp
80100e87:	ff 75 0c             	pushl  0xc(%ebp)
80100e8a:	ff 73 10             	pushl  0x10(%ebx)
80100e8d:	e8 c0 09 00 00       	call   80101852 <stati>
    iunlock(f->ip);
80100e92:	83 c4 04             	add    $0x4,%esp
80100e95:	ff 73 10             	pushl  0x10(%ebx)
80100e98:	e8 a4 08 00 00       	call   80101741 <iunlock>
    return 0;
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea8:	c9                   	leave  
80100ea9:	c3                   	ret    
  return -1;
80100eaa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100eaf:	eb f4                	jmp    80100ea5 <filestat+0x3f>

80100eb1 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100eb1:	f3 0f 1e fb          	endbr32 
80100eb5:	55                   	push   %ebp
80100eb6:	89 e5                	mov    %esp,%ebp
80100eb8:	56                   	push   %esi
80100eb9:	53                   	push   %ebx
80100eba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100ebd:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100ec1:	74 70                	je     80100f33 <fileread+0x82>
    return -1;
  if(f->type == FD_PIPE)
80100ec3:	8b 03                	mov    (%ebx),%eax
80100ec5:	83 f8 01             	cmp    $0x1,%eax
80100ec8:	74 44                	je     80100f0e <fileread+0x5d>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100eca:	83 f8 02             	cmp    $0x2,%eax
80100ecd:	75 57                	jne    80100f26 <fileread+0x75>
    ilock(f->ip);
80100ecf:	83 ec 0c             	sub    $0xc,%esp
80100ed2:	ff 73 10             	pushl  0x10(%ebx)
80100ed5:	e8 a1 07 00 00       	call   8010167b <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100eda:	ff 75 10             	pushl  0x10(%ebp)
80100edd:	ff 73 14             	pushl  0x14(%ebx)
80100ee0:	ff 75 0c             	pushl  0xc(%ebp)
80100ee3:	ff 73 10             	pushl  0x10(%ebx)
80100ee6:	e8 96 09 00 00       	call   80101881 <readi>
80100eeb:	89 c6                	mov    %eax,%esi
80100eed:	83 c4 20             	add    $0x20,%esp
80100ef0:	85 c0                	test   %eax,%eax
80100ef2:	7e 03                	jle    80100ef7 <fileread+0x46>
      f->off += r;
80100ef4:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100ef7:	83 ec 0c             	sub    $0xc,%esp
80100efa:	ff 73 10             	pushl  0x10(%ebx)
80100efd:	e8 3f 08 00 00       	call   80101741 <iunlock>
    return r;
80100f02:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100f05:	89 f0                	mov    %esi,%eax
80100f07:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100f0a:	5b                   	pop    %ebx
80100f0b:	5e                   	pop    %esi
80100f0c:	5d                   	pop    %ebp
80100f0d:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100f0e:	83 ec 04             	sub    $0x4,%esp
80100f11:	ff 75 10             	pushl  0x10(%ebp)
80100f14:	ff 75 0c             	pushl  0xc(%ebp)
80100f17:	ff 73 0c             	pushl  0xc(%ebx)
80100f1a:	e8 ce 21 00 00       	call   801030ed <piperead>
80100f1f:	89 c6                	mov    %eax,%esi
80100f21:	83 c4 10             	add    $0x10,%esp
80100f24:	eb df                	jmp    80100f05 <fileread+0x54>
  panic("fileread");
80100f26:	83 ec 0c             	sub    $0xc,%esp
80100f29:	68 9a 7c 10 80       	push   $0x80107c9a
80100f2e:	e8 29 f4 ff ff       	call   8010035c <panic>
    return -1;
80100f33:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100f38:	eb cb                	jmp    80100f05 <fileread+0x54>

80100f3a <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100f3a:	f3 0f 1e fb          	endbr32 
80100f3e:	55                   	push   %ebp
80100f3f:	89 e5                	mov    %esp,%ebp
80100f41:	57                   	push   %edi
80100f42:	56                   	push   %esi
80100f43:	53                   	push   %ebx
80100f44:	83 ec 1c             	sub    $0x1c,%esp
80100f47:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100f4a:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100f4e:	0f 84 cc 00 00 00    	je     80101020 <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100f54:	8b 06                	mov    (%esi),%eax
80100f56:	83 f8 01             	cmp    $0x1,%eax
80100f59:	74 10                	je     80100f6b <filewrite+0x31>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5b:	83 f8 02             	cmp    $0x2,%eax
80100f5e:	0f 85 af 00 00 00    	jne    80101013 <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100f64:	bf 00 00 00 00       	mov    $0x0,%edi
80100f69:	eb 67                	jmp    80100fd2 <filewrite+0x98>
    return pipewrite(f->pipe, addr, n);
80100f6b:	83 ec 04             	sub    $0x4,%esp
80100f6e:	ff 75 10             	pushl  0x10(%ebp)
80100f71:	ff 75 0c             	pushl  0xc(%ebp)
80100f74:	ff 76 0c             	pushl  0xc(%esi)
80100f77:	e8 a7 20 00 00       	call   80103023 <pipewrite>
80100f7c:	83 c4 10             	add    $0x10,%esp
80100f7f:	e9 82 00 00 00       	jmp    80101006 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100f84:	e8 77 19 00 00       	call   80102900 <begin_op>
      ilock(f->ip);
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	ff 76 10             	pushl  0x10(%esi)
80100f8f:	e8 e7 06 00 00       	call   8010167b <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100f94:	ff 75 e4             	pushl  -0x1c(%ebp)
80100f97:	ff 76 14             	pushl  0x14(%esi)
80100f9a:	89 f8                	mov    %edi,%eax
80100f9c:	03 45 0c             	add    0xc(%ebp),%eax
80100f9f:	50                   	push   %eax
80100fa0:	ff 76 10             	pushl  0x10(%esi)
80100fa3:	e8 da 09 00 00       	call   80101982 <writei>
80100fa8:	89 c3                	mov    %eax,%ebx
80100faa:	83 c4 20             	add    $0x20,%esp
80100fad:	85 c0                	test   %eax,%eax
80100faf:	7e 03                	jle    80100fb4 <filewrite+0x7a>
        f->off += r;
80100fb1:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100fb4:	83 ec 0c             	sub    $0xc,%esp
80100fb7:	ff 76 10             	pushl  0x10(%esi)
80100fba:	e8 82 07 00 00       	call   80101741 <iunlock>
      end_op();
80100fbf:	e8 ba 19 00 00       	call   8010297e <end_op>

      if(r < 0)
80100fc4:	83 c4 10             	add    $0x10,%esp
80100fc7:	85 db                	test   %ebx,%ebx
80100fc9:	78 31                	js     80100ffc <filewrite+0xc2>
        break;
      if(r != n1)
80100fcb:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100fce:	75 1f                	jne    80100fef <filewrite+0xb5>
        panic("short filewrite");
      i += r;
80100fd0:	01 df                	add    %ebx,%edi
    while(i < n){
80100fd2:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100fd5:	7d 25                	jge    80100ffc <filewrite+0xc2>
      int n1 = n - i;
80100fd7:	8b 45 10             	mov    0x10(%ebp),%eax
80100fda:	29 f8                	sub    %edi,%eax
80100fdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100fdf:	3d 00 06 00 00       	cmp    $0x600,%eax
80100fe4:	7e 9e                	jle    80100f84 <filewrite+0x4a>
        n1 = max;
80100fe6:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100fed:	eb 95                	jmp    80100f84 <filewrite+0x4a>
        panic("short filewrite");
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	68 a3 7c 10 80       	push   $0x80107ca3
80100ff7:	e8 60 f3 ff ff       	call   8010035c <panic>
    }
    return i == n ? n : -1;
80100ffc:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100fff:	74 0d                	je     8010100e <filewrite+0xd4>
80101001:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101006:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101009:	5b                   	pop    %ebx
8010100a:	5e                   	pop    %esi
8010100b:	5f                   	pop    %edi
8010100c:	5d                   	pop    %ebp
8010100d:	c3                   	ret    
    return i == n ? n : -1;
8010100e:	8b 45 10             	mov    0x10(%ebp),%eax
80101011:	eb f3                	jmp    80101006 <filewrite+0xcc>
  panic("filewrite");
80101013:	83 ec 0c             	sub    $0xc,%esp
80101016:	68 a9 7c 10 80       	push   $0x80107ca9
8010101b:	e8 3c f3 ff ff       	call   8010035c <panic>
    return -1;
80101020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101025:	eb df                	jmp    80101006 <filewrite+0xcc>

80101027 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80101027:	55                   	push   %ebp
80101028:	89 e5                	mov    %esp,%ebp
8010102a:	57                   	push   %edi
8010102b:	56                   	push   %esi
8010102c:	53                   	push   %ebx
8010102d:	83 ec 0c             	sub    $0xc,%esp
80101030:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80101032:	0f b6 10             	movzbl (%eax),%edx
80101035:	80 fa 2f             	cmp    $0x2f,%dl
80101038:	75 05                	jne    8010103f <skipelem+0x18>
    path++;
8010103a:	83 c0 01             	add    $0x1,%eax
8010103d:	eb f3                	jmp    80101032 <skipelem+0xb>
  if(*path == 0)
8010103f:	84 d2                	test   %dl,%dl
80101041:	74 59                	je     8010109c <skipelem+0x75>
80101043:	89 c3                	mov    %eax,%ebx
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101045:	0f b6 13             	movzbl (%ebx),%edx
80101048:	80 fa 2f             	cmp    $0x2f,%dl
8010104b:	0f 95 c1             	setne  %cl
8010104e:	84 d2                	test   %dl,%dl
80101050:	0f 95 c2             	setne  %dl
80101053:	84 d1                	test   %dl,%cl
80101055:	74 05                	je     8010105c <skipelem+0x35>
    path++;
80101057:	83 c3 01             	add    $0x1,%ebx
8010105a:	eb e9                	jmp    80101045 <skipelem+0x1e>
  len = path - s;
8010105c:	89 df                	mov    %ebx,%edi
8010105e:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80101060:	83 ff 0d             	cmp    $0xd,%edi
80101063:	7e 11                	jle    80101076 <skipelem+0x4f>
    memmove(name, s, DIRSIZ);
80101065:	83 ec 04             	sub    $0x4,%esp
80101068:	6a 0e                	push   $0xe
8010106a:	50                   	push   %eax
8010106b:	56                   	push   %esi
8010106c:	e8 5e 41 00 00       	call   801051cf <memmove>
80101071:	83 c4 10             	add    $0x10,%esp
80101074:	eb 17                	jmp    8010108d <skipelem+0x66>
  else {
    memmove(name, s, len);
80101076:	83 ec 04             	sub    $0x4,%esp
80101079:	57                   	push   %edi
8010107a:	50                   	push   %eax
8010107b:	56                   	push   %esi
8010107c:	e8 4e 41 00 00       	call   801051cf <memmove>
    name[len] = 0;
80101081:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80101085:	83 c4 10             	add    $0x10,%esp
80101088:	eb 03                	jmp    8010108d <skipelem+0x66>
  }
  while(*path == '/')
    path++;
8010108a:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010108d:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101090:	74 f8                	je     8010108a <skipelem+0x63>
  return path;
}
80101092:	89 d8                	mov    %ebx,%eax
80101094:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101097:	5b                   	pop    %ebx
80101098:	5e                   	pop    %esi
80101099:	5f                   	pop    %edi
8010109a:	5d                   	pop    %ebp
8010109b:	c3                   	ret    
    return 0;
8010109c:	bb 00 00 00 00       	mov    $0x0,%ebx
801010a1:	eb ef                	jmp    80101092 <skipelem+0x6b>

801010a3 <bzero>:
{
801010a3:	55                   	push   %ebp
801010a4:	89 e5                	mov    %esp,%ebp
801010a6:	53                   	push   %ebx
801010a7:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
801010aa:	52                   	push   %edx
801010ab:	50                   	push   %eax
801010ac:	e8 bf f0 ff ff       	call   80100170 <bread>
801010b1:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801010b3:	8d 40 5c             	lea    0x5c(%eax),%eax
801010b6:	83 c4 0c             	add    $0xc,%esp
801010b9:	68 00 02 00 00       	push   $0x200
801010be:	6a 00                	push   $0x0
801010c0:	50                   	push   %eax
801010c1:	e8 89 40 00 00       	call   8010514f <memset>
  log_write(bp);
801010c6:	89 1c 24             	mov    %ebx,(%esp)
801010c9:	e8 63 19 00 00       	call   80102a31 <log_write>
  brelse(bp);
801010ce:	89 1c 24             	mov    %ebx,(%esp)
801010d1:	e8 0b f1 ff ff       	call   801001e1 <brelse>
}
801010d6:	83 c4 10             	add    $0x10,%esp
801010d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010dc:	c9                   	leave  
801010dd:	c3                   	ret    

801010de <balloc>:
{
801010de:	55                   	push   %ebp
801010df:	89 e5                	mov    %esp,%ebp
801010e1:	57                   	push   %edi
801010e2:	56                   	push   %esi
801010e3:	53                   	push   %ebx
801010e4:	83 ec 1c             	sub    $0x1c,%esp
801010e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801010ea:	be 00 00 00 00       	mov    $0x0,%esi
801010ef:	eb 14                	jmp    80101105 <balloc+0x27>
    brelse(bp);
801010f1:	83 ec 0c             	sub    $0xc,%esp
801010f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801010f7:	e8 e5 f0 ff ff       	call   801001e1 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801010fc:	81 c6 00 10 00 00    	add    $0x1000,%esi
80101102:	83 c4 10             	add    $0x10,%esp
80101105:	39 35 a0 41 11 80    	cmp    %esi,0x801141a0
8010110b:	76 75                	jbe    80101182 <balloc+0xa4>
    bp = bread(dev, BBLOCK(b, sb));
8010110d:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
80101113:	85 f6                	test   %esi,%esi
80101115:	0f 49 c6             	cmovns %esi,%eax
80101118:	c1 f8 0c             	sar    $0xc,%eax
8010111b:	83 ec 08             	sub    $0x8,%esp
8010111e:	03 05 b8 41 11 80    	add    0x801141b8,%eax
80101124:	50                   	push   %eax
80101125:	ff 75 d8             	pushl  -0x28(%ebp)
80101128:	e8 43 f0 ff ff       	call   80100170 <bread>
8010112d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101130:	83 c4 10             	add    $0x10,%esp
80101133:	b8 00 00 00 00       	mov    $0x0,%eax
80101138:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010113d:	7f b2                	jg     801010f1 <balloc+0x13>
8010113f:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80101142:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80101145:	3b 1d a0 41 11 80    	cmp    0x801141a0,%ebx
8010114b:	73 a4                	jae    801010f1 <balloc+0x13>
      m = 1 << (bi % 8);
8010114d:	99                   	cltd   
8010114e:	c1 ea 1d             	shr    $0x1d,%edx
80101151:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
80101154:	83 e1 07             	and    $0x7,%ecx
80101157:	29 d1                	sub    %edx,%ecx
80101159:	ba 01 00 00 00       	mov    $0x1,%edx
8010115e:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101160:	8d 48 07             	lea    0x7(%eax),%ecx
80101163:	85 c0                	test   %eax,%eax
80101165:	0f 49 c8             	cmovns %eax,%ecx
80101168:	c1 f9 03             	sar    $0x3,%ecx
8010116b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
8010116e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101171:	0f b6 4c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%ecx
80101176:	0f b6 f9             	movzbl %cl,%edi
80101179:	85 d7                	test   %edx,%edi
8010117b:	74 12                	je     8010118f <balloc+0xb1>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117d:	83 c0 01             	add    $0x1,%eax
80101180:	eb b6                	jmp    80101138 <balloc+0x5a>
  panic("balloc: out of blocks");
80101182:	83 ec 0c             	sub    $0xc,%esp
80101185:	68 b3 7c 10 80       	push   $0x80107cb3
8010118a:	e8 cd f1 ff ff       	call   8010035c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
8010118f:	09 ca                	or     %ecx,%edx
80101191:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101194:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101197:	88 54 30 5c          	mov    %dl,0x5c(%eax,%esi,1)
        log_write(bp);
8010119b:	83 ec 0c             	sub    $0xc,%esp
8010119e:	89 c6                	mov    %eax,%esi
801011a0:	50                   	push   %eax
801011a1:	e8 8b 18 00 00       	call   80102a31 <log_write>
        brelse(bp);
801011a6:	89 34 24             	mov    %esi,(%esp)
801011a9:	e8 33 f0 ff ff       	call   801001e1 <brelse>
        bzero(dev, b + bi);
801011ae:	89 da                	mov    %ebx,%edx
801011b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011b3:	e8 eb fe ff ff       	call   801010a3 <bzero>
}
801011b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011be:	5b                   	pop    %ebx
801011bf:	5e                   	pop    %esi
801011c0:	5f                   	pop    %edi
801011c1:	5d                   	pop    %ebp
801011c2:	c3                   	ret    

801011c3 <bmap>:
{
801011c3:	55                   	push   %ebp
801011c4:	89 e5                	mov    %esp,%ebp
801011c6:	57                   	push   %edi
801011c7:	56                   	push   %esi
801011c8:	53                   	push   %ebx
801011c9:	83 ec 1c             	sub    $0x1c,%esp
801011cc:	89 c3                	mov    %eax,%ebx
801011ce:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
801011d0:	83 fa 0b             	cmp    $0xb,%edx
801011d3:	76 45                	jbe    8010121a <bmap+0x57>
  bn -= NDIRECT;
801011d5:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801011d8:	83 fe 7f             	cmp    $0x7f,%esi
801011db:	77 7f                	ja     8010125c <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
801011dd:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801011e3:	85 c0                	test   %eax,%eax
801011e5:	74 4a                	je     80101231 <bmap+0x6e>
    bp = bread(ip->dev, addr);
801011e7:	83 ec 08             	sub    $0x8,%esp
801011ea:	50                   	push   %eax
801011eb:	ff 33                	pushl  (%ebx)
801011ed:	e8 7e ef ff ff       	call   80100170 <bread>
801011f2:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801011f4:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
801011f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011fb:	8b 30                	mov    (%eax),%esi
801011fd:	83 c4 10             	add    $0x10,%esp
80101200:	85 f6                	test   %esi,%esi
80101202:	74 3c                	je     80101240 <bmap+0x7d>
    brelse(bp);
80101204:	83 ec 0c             	sub    $0xc,%esp
80101207:	57                   	push   %edi
80101208:	e8 d4 ef ff ff       	call   801001e1 <brelse>
    return addr;
8010120d:	83 c4 10             	add    $0x10,%esp
}
80101210:	89 f0                	mov    %esi,%eax
80101212:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101215:	5b                   	pop    %ebx
80101216:	5e                   	pop    %esi
80101217:	5f                   	pop    %edi
80101218:	5d                   	pop    %ebp
80101219:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
8010121a:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
8010121e:	85 f6                	test   %esi,%esi
80101220:	75 ee                	jne    80101210 <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101222:	8b 00                	mov    (%eax),%eax
80101224:	e8 b5 fe ff ff       	call   801010de <balloc>
80101229:	89 c6                	mov    %eax,%esi
8010122b:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
8010122f:	eb df                	jmp    80101210 <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101231:	8b 03                	mov    (%ebx),%eax
80101233:	e8 a6 fe ff ff       	call   801010de <balloc>
80101238:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
8010123e:	eb a7                	jmp    801011e7 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
80101240:	8b 03                	mov    (%ebx),%eax
80101242:	e8 97 fe ff ff       	call   801010de <balloc>
80101247:	89 c6                	mov    %eax,%esi
80101249:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010124c:	89 30                	mov    %esi,(%eax)
      log_write(bp);
8010124e:	83 ec 0c             	sub    $0xc,%esp
80101251:	57                   	push   %edi
80101252:	e8 da 17 00 00       	call   80102a31 <log_write>
80101257:	83 c4 10             	add    $0x10,%esp
8010125a:	eb a8                	jmp    80101204 <bmap+0x41>
  panic("bmap: out of range");
8010125c:	83 ec 0c             	sub    $0xc,%esp
8010125f:	68 c9 7c 10 80       	push   $0x80107cc9
80101264:	e8 f3 f0 ff ff       	call   8010035c <panic>

80101269 <iget>:
{
80101269:	55                   	push   %ebp
8010126a:	89 e5                	mov    %esp,%ebp
8010126c:	57                   	push   %edi
8010126d:	56                   	push   %esi
8010126e:	53                   	push   %ebx
8010126f:	83 ec 28             	sub    $0x28,%esp
80101272:	89 c7                	mov    %eax,%edi
80101274:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101277:	68 c0 41 11 80       	push   $0x801141c0
8010127c:	e8 1a 3e 00 00       	call   8010509b <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101281:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101284:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101289:	bb f4 41 11 80       	mov    $0x801141f4,%ebx
8010128e:	eb 0a                	jmp    8010129a <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101290:	85 f6                	test   %esi,%esi
80101292:	74 3b                	je     801012cf <iget+0x66>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101294:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010129a:	81 fb 14 5e 11 80    	cmp    $0x80115e14,%ebx
801012a0:	73 35                	jae    801012d7 <iget+0x6e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012a2:	8b 43 08             	mov    0x8(%ebx),%eax
801012a5:	85 c0                	test   %eax,%eax
801012a7:	7e e7                	jle    80101290 <iget+0x27>
801012a9:	39 3b                	cmp    %edi,(%ebx)
801012ab:	75 e3                	jne    80101290 <iget+0x27>
801012ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801012b0:	39 4b 04             	cmp    %ecx,0x4(%ebx)
801012b3:	75 db                	jne    80101290 <iget+0x27>
      ip->ref++;
801012b5:	83 c0 01             	add    $0x1,%eax
801012b8:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801012bb:	83 ec 0c             	sub    $0xc,%esp
801012be:	68 c0 41 11 80       	push   $0x801141c0
801012c3:	e8 3c 3e 00 00       	call   80105104 <release>
      return ip;
801012c8:	83 c4 10             	add    $0x10,%esp
801012cb:	89 de                	mov    %ebx,%esi
801012cd:	eb 32                	jmp    80101301 <iget+0x98>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012cf:	85 c0                	test   %eax,%eax
801012d1:	75 c1                	jne    80101294 <iget+0x2b>
      empty = ip;
801012d3:	89 de                	mov    %ebx,%esi
801012d5:	eb bd                	jmp    80101294 <iget+0x2b>
  if(empty == 0)
801012d7:	85 f6                	test   %esi,%esi
801012d9:	74 30                	je     8010130b <iget+0xa2>
  ip->dev = dev;
801012db:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012e0:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
801012e3:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012ea:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 c0 41 11 80       	push   $0x801141c0
801012f9:	e8 06 3e 00 00       	call   80105104 <release>
  return ip;
801012fe:	83 c4 10             	add    $0x10,%esp
}
80101301:	89 f0                	mov    %esi,%eax
80101303:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101306:	5b                   	pop    %ebx
80101307:	5e                   	pop    %esi
80101308:	5f                   	pop    %edi
80101309:	5d                   	pop    %ebp
8010130a:	c3                   	ret    
    panic("iget: no inodes");
8010130b:	83 ec 0c             	sub    $0xc,%esp
8010130e:	68 dc 7c 10 80       	push   $0x80107cdc
80101313:	e8 44 f0 ff ff       	call   8010035c <panic>

80101318 <readsb>:
{
80101318:	f3 0f 1e fb          	endbr32 
8010131c:	55                   	push   %ebp
8010131d:	89 e5                	mov    %esp,%ebp
8010131f:	53                   	push   %ebx
80101320:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
80101323:	6a 01                	push   $0x1
80101325:	ff 75 08             	pushl  0x8(%ebp)
80101328:	e8 43 ee ff ff       	call   80100170 <bread>
8010132d:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010132f:	8d 40 5c             	lea    0x5c(%eax),%eax
80101332:	83 c4 0c             	add    $0xc,%esp
80101335:	6a 1c                	push   $0x1c
80101337:	50                   	push   %eax
80101338:	ff 75 0c             	pushl  0xc(%ebp)
8010133b:	e8 8f 3e 00 00       	call   801051cf <memmove>
  brelse(bp);
80101340:	89 1c 24             	mov    %ebx,(%esp)
80101343:	e8 99 ee ff ff       	call   801001e1 <brelse>
}
80101348:	83 c4 10             	add    $0x10,%esp
8010134b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010134e:	c9                   	leave  
8010134f:	c3                   	ret    

80101350 <bfree>:
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	83 ec 14             	sub    $0x14,%esp
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 d6                	mov    %edx,%esi
  readsb(dev, &sb);
8010135d:	68 a0 41 11 80       	push   $0x801141a0
80101362:	50                   	push   %eax
80101363:	e8 b0 ff ff ff       	call   80101318 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101368:	89 f0                	mov    %esi,%eax
8010136a:	c1 e8 0c             	shr    $0xc,%eax
8010136d:	83 c4 08             	add    $0x8,%esp
80101370:	03 05 b8 41 11 80    	add    0x801141b8,%eax
80101376:	50                   	push   %eax
80101377:	53                   	push   %ebx
80101378:	e8 f3 ed ff ff       	call   80100170 <bread>
8010137d:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
8010137f:	89 f7                	mov    %esi,%edi
80101381:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  m = 1 << (bi % 8);
80101387:	89 f1                	mov    %esi,%ecx
80101389:	83 e1 07             	and    $0x7,%ecx
8010138c:	b8 01 00 00 00       	mov    $0x1,%eax
80101391:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101393:	83 c4 10             	add    $0x10,%esp
80101396:	c1 ff 03             	sar    $0x3,%edi
80101399:	0f b6 54 3b 5c       	movzbl 0x5c(%ebx,%edi,1),%edx
8010139e:	0f b6 ca             	movzbl %dl,%ecx
801013a1:	85 c1                	test   %eax,%ecx
801013a3:	74 24                	je     801013c9 <bfree+0x79>
  bp->data[bi/8] &= ~m;
801013a5:	f7 d0                	not    %eax
801013a7:	21 d0                	and    %edx,%eax
801013a9:	88 44 3b 5c          	mov    %al,0x5c(%ebx,%edi,1)
  log_write(bp);
801013ad:	83 ec 0c             	sub    $0xc,%esp
801013b0:	53                   	push   %ebx
801013b1:	e8 7b 16 00 00       	call   80102a31 <log_write>
  brelse(bp);
801013b6:	89 1c 24             	mov    %ebx,(%esp)
801013b9:	e8 23 ee ff ff       	call   801001e1 <brelse>
}
801013be:	83 c4 10             	add    $0x10,%esp
801013c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013c4:	5b                   	pop    %ebx
801013c5:	5e                   	pop    %esi
801013c6:	5f                   	pop    %edi
801013c7:	5d                   	pop    %ebp
801013c8:	c3                   	ret    
    panic("freeing free block");
801013c9:	83 ec 0c             	sub    $0xc,%esp
801013cc:	68 ec 7c 10 80       	push   $0x80107cec
801013d1:	e8 86 ef ff ff       	call   8010035c <panic>

801013d6 <iinit>:
{
801013d6:	f3 0f 1e fb          	endbr32 
801013da:	55                   	push   %ebp
801013db:	89 e5                	mov    %esp,%ebp
801013dd:	53                   	push   %ebx
801013de:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801013e1:	68 ff 7c 10 80       	push   $0x80107cff
801013e6:	68 c0 41 11 80       	push   $0x801141c0
801013eb:	e8 5b 3b 00 00       	call   80104f4b <initlock>
  for(i = 0; i < NINODE; i++) {
801013f0:	83 c4 10             	add    $0x10,%esp
801013f3:	bb 00 00 00 00       	mov    $0x0,%ebx
801013f8:	83 fb 31             	cmp    $0x31,%ebx
801013fb:	7f 23                	jg     80101420 <iinit+0x4a>
    initsleeplock(&icache.inode[i].lock, "inode");
801013fd:	83 ec 08             	sub    $0x8,%esp
80101400:	68 06 7d 10 80       	push   $0x80107d06
80101405:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80101408:	89 d0                	mov    %edx,%eax
8010140a:	c1 e0 04             	shl    $0x4,%eax
8010140d:	05 00 42 11 80       	add    $0x80114200,%eax
80101412:	50                   	push   %eax
80101413:	e8 3f 3a 00 00       	call   80104e57 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101418:	83 c3 01             	add    $0x1,%ebx
8010141b:	83 c4 10             	add    $0x10,%esp
8010141e:	eb d8                	jmp    801013f8 <iinit+0x22>
  readsb(dev, &sb);
80101420:	83 ec 08             	sub    $0x8,%esp
80101423:	68 a0 41 11 80       	push   $0x801141a0
80101428:	ff 75 08             	pushl  0x8(%ebp)
8010142b:	e8 e8 fe ff ff       	call   80101318 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101430:	ff 35 b8 41 11 80    	pushl  0x801141b8
80101436:	ff 35 b4 41 11 80    	pushl  0x801141b4
8010143c:	ff 35 b0 41 11 80    	pushl  0x801141b0
80101442:	ff 35 ac 41 11 80    	pushl  0x801141ac
80101448:	ff 35 a8 41 11 80    	pushl  0x801141a8
8010144e:	ff 35 a4 41 11 80    	pushl  0x801141a4
80101454:	ff 35 a0 41 11 80    	pushl  0x801141a0
8010145a:	68 6c 7d 10 80       	push   $0x80107d6c
8010145f:	e8 c5 f1 ff ff       	call   80100629 <cprintf>
}
80101464:	83 c4 30             	add    $0x30,%esp
80101467:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010146a:	c9                   	leave  
8010146b:	c3                   	ret    

8010146c <ialloc>:
{
8010146c:	f3 0f 1e fb          	endbr32 
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	53                   	push   %ebx
80101476:	83 ec 1c             	sub    $0x1c,%esp
80101479:	8b 45 0c             	mov    0xc(%ebp),%eax
8010147c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010147f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101484:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101487:	39 1d a8 41 11 80    	cmp    %ebx,0x801141a8
8010148d:	76 76                	jbe    80101505 <ialloc+0x99>
    bp = bread(dev, IBLOCK(inum, sb));
8010148f:	89 d8                	mov    %ebx,%eax
80101491:	c1 e8 03             	shr    $0x3,%eax
80101494:	83 ec 08             	sub    $0x8,%esp
80101497:	03 05 b4 41 11 80    	add    0x801141b4,%eax
8010149d:	50                   	push   %eax
8010149e:	ff 75 08             	pushl  0x8(%ebp)
801014a1:	e8 ca ec ff ff       	call   80100170 <bread>
801014a6:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801014a8:	89 d8                	mov    %ebx,%eax
801014aa:	83 e0 07             	and    $0x7,%eax
801014ad:	c1 e0 06             	shl    $0x6,%eax
801014b0:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	66 83 3f 00          	cmpw   $0x0,(%edi)
801014bb:	74 11                	je     801014ce <ialloc+0x62>
    brelse(bp);
801014bd:	83 ec 0c             	sub    $0xc,%esp
801014c0:	56                   	push   %esi
801014c1:	e8 1b ed ff ff       	call   801001e1 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801014c6:	83 c3 01             	add    $0x1,%ebx
801014c9:	83 c4 10             	add    $0x10,%esp
801014cc:	eb b6                	jmp    80101484 <ialloc+0x18>
      memset(dip, 0, sizeof(*dip));
801014ce:	83 ec 04             	sub    $0x4,%esp
801014d1:	6a 40                	push   $0x40
801014d3:	6a 00                	push   $0x0
801014d5:	57                   	push   %edi
801014d6:	e8 74 3c 00 00       	call   8010514f <memset>
      dip->type = type;
801014db:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801014df:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
801014e2:	89 34 24             	mov    %esi,(%esp)
801014e5:	e8 47 15 00 00       	call   80102a31 <log_write>
      brelse(bp);
801014ea:	89 34 24             	mov    %esi,(%esp)
801014ed:	e8 ef ec ff ff       	call   801001e1 <brelse>
      return iget(dev, inum);
801014f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014f5:	8b 45 08             	mov    0x8(%ebp),%eax
801014f8:	e8 6c fd ff ff       	call   80101269 <iget>
}
801014fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101500:	5b                   	pop    %ebx
80101501:	5e                   	pop    %esi
80101502:	5f                   	pop    %edi
80101503:	5d                   	pop    %ebp
80101504:	c3                   	ret    
  panic("ialloc: no inodes");
80101505:	83 ec 0c             	sub    $0xc,%esp
80101508:	68 0c 7d 10 80       	push   $0x80107d0c
8010150d:	e8 4a ee ff ff       	call   8010035c <panic>

80101512 <iupdate>:
{
80101512:	f3 0f 1e fb          	endbr32 
80101516:	55                   	push   %ebp
80101517:	89 e5                	mov    %esp,%ebp
80101519:	56                   	push   %esi
8010151a:	53                   	push   %ebx
8010151b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010151e:	8b 43 04             	mov    0x4(%ebx),%eax
80101521:	c1 e8 03             	shr    $0x3,%eax
80101524:	83 ec 08             	sub    $0x8,%esp
80101527:	03 05 b4 41 11 80    	add    0x801141b4,%eax
8010152d:	50                   	push   %eax
8010152e:	ff 33                	pushl  (%ebx)
80101530:	e8 3b ec ff ff       	call   80100170 <bread>
80101535:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101537:	8b 43 04             	mov    0x4(%ebx),%eax
8010153a:	83 e0 07             	and    $0x7,%eax
8010153d:	c1 e0 06             	shl    $0x6,%eax
80101540:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101544:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
80101548:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010154b:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
8010154f:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101553:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
80101557:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010155b:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
8010155f:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101563:	8b 53 58             	mov    0x58(%ebx),%edx
80101566:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101569:	83 c3 5c             	add    $0x5c,%ebx
8010156c:	83 c0 0c             	add    $0xc,%eax
8010156f:	83 c4 0c             	add    $0xc,%esp
80101572:	6a 34                	push   $0x34
80101574:	53                   	push   %ebx
80101575:	50                   	push   %eax
80101576:	e8 54 3c 00 00       	call   801051cf <memmove>
  log_write(bp);
8010157b:	89 34 24             	mov    %esi,(%esp)
8010157e:	e8 ae 14 00 00       	call   80102a31 <log_write>
  brelse(bp);
80101583:	89 34 24             	mov    %esi,(%esp)
80101586:	e8 56 ec ff ff       	call   801001e1 <brelse>
}
8010158b:	83 c4 10             	add    $0x10,%esp
8010158e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101591:	5b                   	pop    %ebx
80101592:	5e                   	pop    %esi
80101593:	5d                   	pop    %ebp
80101594:	c3                   	ret    

80101595 <itrunc>:
{
80101595:	55                   	push   %ebp
80101596:	89 e5                	mov    %esp,%ebp
80101598:	57                   	push   %edi
80101599:	56                   	push   %esi
8010159a:	53                   	push   %ebx
8010159b:	83 ec 1c             	sub    $0x1c,%esp
8010159e:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
801015a0:	bb 00 00 00 00       	mov    $0x0,%ebx
801015a5:	eb 03                	jmp    801015aa <itrunc+0x15>
801015a7:	83 c3 01             	add    $0x1,%ebx
801015aa:	83 fb 0b             	cmp    $0xb,%ebx
801015ad:	7f 19                	jg     801015c8 <itrunc+0x33>
    if(ip->addrs[i]){
801015af:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
801015b3:	85 d2                	test   %edx,%edx
801015b5:	74 f0                	je     801015a7 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
801015b7:	8b 06                	mov    (%esi),%eax
801015b9:	e8 92 fd ff ff       	call   80101350 <bfree>
      ip->addrs[i] = 0;
801015be:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
801015c5:	00 
801015c6:	eb df                	jmp    801015a7 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
801015c8:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801015ce:	85 c0                	test   %eax,%eax
801015d0:	75 1b                	jne    801015ed <itrunc+0x58>
  ip->size = 0;
801015d2:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801015d9:	83 ec 0c             	sub    $0xc,%esp
801015dc:	56                   	push   %esi
801015dd:	e8 30 ff ff ff       	call   80101512 <iupdate>
}
801015e2:	83 c4 10             	add    $0x10,%esp
801015e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015e8:	5b                   	pop    %ebx
801015e9:	5e                   	pop    %esi
801015ea:	5f                   	pop    %edi
801015eb:	5d                   	pop    %ebp
801015ec:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801015ed:	83 ec 08             	sub    $0x8,%esp
801015f0:	50                   	push   %eax
801015f1:	ff 36                	pushl  (%esi)
801015f3:	e8 78 eb ff ff       	call   80100170 <bread>
801015f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801015fb:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
801015fe:	83 c4 10             	add    $0x10,%esp
80101601:	bb 00 00 00 00       	mov    $0x0,%ebx
80101606:	eb 0a                	jmp    80101612 <itrunc+0x7d>
        bfree(ip->dev, a[j]);
80101608:	8b 06                	mov    (%esi),%eax
8010160a:	e8 41 fd ff ff       	call   80101350 <bfree>
    for(j = 0; j < NINDIRECT; j++){
8010160f:	83 c3 01             	add    $0x1,%ebx
80101612:	83 fb 7f             	cmp    $0x7f,%ebx
80101615:	77 09                	ja     80101620 <itrunc+0x8b>
      if(a[j])
80101617:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
8010161a:	85 d2                	test   %edx,%edx
8010161c:	74 f1                	je     8010160f <itrunc+0x7a>
8010161e:	eb e8                	jmp    80101608 <itrunc+0x73>
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
80101623:	ff 75 e4             	pushl  -0x1c(%ebp)
80101626:	e8 b6 eb ff ff       	call   801001e1 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010162b:	8b 06                	mov    (%esi),%eax
8010162d:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101633:	e8 18 fd ff ff       	call   80101350 <bfree>
    ip->addrs[NDIRECT] = 0;
80101638:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010163f:	00 00 00 
80101642:	83 c4 10             	add    $0x10,%esp
80101645:	eb 8b                	jmp    801015d2 <itrunc+0x3d>

80101647 <idup>:
{
80101647:	f3 0f 1e fb          	endbr32 
8010164b:	55                   	push   %ebp
8010164c:	89 e5                	mov    %esp,%ebp
8010164e:	53                   	push   %ebx
8010164f:	83 ec 10             	sub    $0x10,%esp
80101652:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101655:	68 c0 41 11 80       	push   $0x801141c0
8010165a:	e8 3c 3a 00 00       	call   8010509b <acquire>
  ip->ref++;
8010165f:	8b 43 08             	mov    0x8(%ebx),%eax
80101662:	83 c0 01             	add    $0x1,%eax
80101665:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101668:	c7 04 24 c0 41 11 80 	movl   $0x801141c0,(%esp)
8010166f:	e8 90 3a 00 00       	call   80105104 <release>
}
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    

8010167b <ilock>:
{
8010167b:	f3 0f 1e fb          	endbr32 
8010167f:	55                   	push   %ebp
80101680:	89 e5                	mov    %esp,%ebp
80101682:	56                   	push   %esi
80101683:	53                   	push   %ebx
80101684:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101687:	85 db                	test   %ebx,%ebx
80101689:	74 22                	je     801016ad <ilock+0x32>
8010168b:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
8010168f:	7e 1c                	jle    801016ad <ilock+0x32>
  acquiresleep(&ip->lock);
80101691:	83 ec 0c             	sub    $0xc,%esp
80101694:	8d 43 0c             	lea    0xc(%ebx),%eax
80101697:	50                   	push   %eax
80101698:	e8 f1 37 00 00       	call   80104e8e <acquiresleep>
  if(ip->valid == 0){
8010169d:	83 c4 10             	add    $0x10,%esp
801016a0:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801016a4:	74 14                	je     801016ba <ilock+0x3f>
}
801016a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a9:	5b                   	pop    %ebx
801016aa:	5e                   	pop    %esi
801016ab:	5d                   	pop    %ebp
801016ac:	c3                   	ret    
    panic("ilock");
801016ad:	83 ec 0c             	sub    $0xc,%esp
801016b0:	68 1e 7d 10 80       	push   $0x80107d1e
801016b5:	e8 a2 ec ff ff       	call   8010035c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ba:	8b 43 04             	mov    0x4(%ebx),%eax
801016bd:	c1 e8 03             	shr    $0x3,%eax
801016c0:	83 ec 08             	sub    $0x8,%esp
801016c3:	03 05 b4 41 11 80    	add    0x801141b4,%eax
801016c9:	50                   	push   %eax
801016ca:	ff 33                	pushl  (%ebx)
801016cc:	e8 9f ea ff ff       	call   80100170 <bread>
801016d1:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d3:	8b 43 04             	mov    0x4(%ebx),%eax
801016d6:	83 e0 07             	and    $0x7,%eax
801016d9:	c1 e0 06             	shl    $0x6,%eax
801016dc:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016e0:	0f b7 10             	movzwl (%eax),%edx
801016e3:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016e7:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801016eb:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016ef:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801016f3:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016f7:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801016fb:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016ff:	8b 50 08             	mov    0x8(%eax),%edx
80101702:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101705:	83 c0 0c             	add    $0xc,%eax
80101708:	8d 53 5c             	lea    0x5c(%ebx),%edx
8010170b:	83 c4 0c             	add    $0xc,%esp
8010170e:	6a 34                	push   $0x34
80101710:	50                   	push   %eax
80101711:	52                   	push   %edx
80101712:	e8 b8 3a 00 00       	call   801051cf <memmove>
    brelse(bp);
80101717:	89 34 24             	mov    %esi,(%esp)
8010171a:	e8 c2 ea ff ff       	call   801001e1 <brelse>
    ip->valid = 1;
8010171f:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101726:	83 c4 10             	add    $0x10,%esp
80101729:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010172e:	0f 85 72 ff ff ff    	jne    801016a6 <ilock+0x2b>
      panic("ilock: no type");
80101734:	83 ec 0c             	sub    $0xc,%esp
80101737:	68 24 7d 10 80       	push   $0x80107d24
8010173c:	e8 1b ec ff ff       	call   8010035c <panic>

80101741 <iunlock>:
{
80101741:	f3 0f 1e fb          	endbr32 
80101745:	55                   	push   %ebp
80101746:	89 e5                	mov    %esp,%ebp
80101748:	56                   	push   %esi
80101749:	53                   	push   %ebx
8010174a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010174d:	85 db                	test   %ebx,%ebx
8010174f:	74 2c                	je     8010177d <iunlock+0x3c>
80101751:	8d 73 0c             	lea    0xc(%ebx),%esi
80101754:	83 ec 0c             	sub    $0xc,%esp
80101757:	56                   	push   %esi
80101758:	e8 c3 37 00 00       	call   80104f20 <holdingsleep>
8010175d:	83 c4 10             	add    $0x10,%esp
80101760:	85 c0                	test   %eax,%eax
80101762:	74 19                	je     8010177d <iunlock+0x3c>
80101764:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101768:	7e 13                	jle    8010177d <iunlock+0x3c>
  releasesleep(&ip->lock);
8010176a:	83 ec 0c             	sub    $0xc,%esp
8010176d:	56                   	push   %esi
8010176e:	e8 6e 37 00 00       	call   80104ee1 <releasesleep>
}
80101773:	83 c4 10             	add    $0x10,%esp
80101776:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101779:	5b                   	pop    %ebx
8010177a:	5e                   	pop    %esi
8010177b:	5d                   	pop    %ebp
8010177c:	c3                   	ret    
    panic("iunlock");
8010177d:	83 ec 0c             	sub    $0xc,%esp
80101780:	68 33 7d 10 80       	push   $0x80107d33
80101785:	e8 d2 eb ff ff       	call   8010035c <panic>

8010178a <iput>:
{
8010178a:	f3 0f 1e fb          	endbr32 
8010178e:	55                   	push   %ebp
8010178f:	89 e5                	mov    %esp,%ebp
80101791:	57                   	push   %edi
80101792:	56                   	push   %esi
80101793:	53                   	push   %ebx
80101794:	83 ec 18             	sub    $0x18,%esp
80101797:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010179a:	8d 73 0c             	lea    0xc(%ebx),%esi
8010179d:	56                   	push   %esi
8010179e:	e8 eb 36 00 00       	call   80104e8e <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017a3:	83 c4 10             	add    $0x10,%esp
801017a6:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801017aa:	74 07                	je     801017b3 <iput+0x29>
801017ac:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017b1:	74 35                	je     801017e8 <iput+0x5e>
  releasesleep(&ip->lock);
801017b3:	83 ec 0c             	sub    $0xc,%esp
801017b6:	56                   	push   %esi
801017b7:	e8 25 37 00 00       	call   80104ee1 <releasesleep>
  acquire(&icache.lock);
801017bc:	c7 04 24 c0 41 11 80 	movl   $0x801141c0,(%esp)
801017c3:	e8 d3 38 00 00       	call   8010509b <acquire>
  ip->ref--;
801017c8:	8b 43 08             	mov    0x8(%ebx),%eax
801017cb:	83 e8 01             	sub    $0x1,%eax
801017ce:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801017d1:	c7 04 24 c0 41 11 80 	movl   $0x801141c0,(%esp)
801017d8:	e8 27 39 00 00       	call   80105104 <release>
}
801017dd:	83 c4 10             	add    $0x10,%esp
801017e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017e3:	5b                   	pop    %ebx
801017e4:	5e                   	pop    %esi
801017e5:	5f                   	pop    %edi
801017e6:	5d                   	pop    %ebp
801017e7:	c3                   	ret    
    acquire(&icache.lock);
801017e8:	83 ec 0c             	sub    $0xc,%esp
801017eb:	68 c0 41 11 80       	push   $0x801141c0
801017f0:	e8 a6 38 00 00       	call   8010509b <acquire>
    int r = ip->ref;
801017f5:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801017f8:	c7 04 24 c0 41 11 80 	movl   $0x801141c0,(%esp)
801017ff:	e8 00 39 00 00       	call   80105104 <release>
    if(r == 1){
80101804:	83 c4 10             	add    $0x10,%esp
80101807:	83 ff 01             	cmp    $0x1,%edi
8010180a:	75 a7                	jne    801017b3 <iput+0x29>
      itrunc(ip);
8010180c:	89 d8                	mov    %ebx,%eax
8010180e:	e8 82 fd ff ff       	call   80101595 <itrunc>
      ip->type = 0;
80101813:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101819:	83 ec 0c             	sub    $0xc,%esp
8010181c:	53                   	push   %ebx
8010181d:	e8 f0 fc ff ff       	call   80101512 <iupdate>
      ip->valid = 0;
80101822:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101829:	83 c4 10             	add    $0x10,%esp
8010182c:	eb 85                	jmp    801017b3 <iput+0x29>

8010182e <iunlockput>:
{
8010182e:	f3 0f 1e fb          	endbr32 
80101832:	55                   	push   %ebp
80101833:	89 e5                	mov    %esp,%ebp
80101835:	53                   	push   %ebx
80101836:	83 ec 10             	sub    $0x10,%esp
80101839:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010183c:	53                   	push   %ebx
8010183d:	e8 ff fe ff ff       	call   80101741 <iunlock>
  iput(ip);
80101842:	89 1c 24             	mov    %ebx,(%esp)
80101845:	e8 40 ff ff ff       	call   8010178a <iput>
}
8010184a:	83 c4 10             	add    $0x10,%esp
8010184d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101850:	c9                   	leave  
80101851:	c3                   	ret    

80101852 <stati>:
{
80101852:	f3 0f 1e fb          	endbr32 
80101856:	55                   	push   %ebp
80101857:	89 e5                	mov    %esp,%ebp
80101859:	8b 55 08             	mov    0x8(%ebp),%edx
8010185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
8010185f:	8b 0a                	mov    (%edx),%ecx
80101861:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101864:	8b 4a 04             	mov    0x4(%edx),%ecx
80101867:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
8010186a:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
8010186e:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101871:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101875:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101879:	8b 52 58             	mov    0x58(%edx),%edx
8010187c:	89 50 10             	mov    %edx,0x10(%eax)
}
8010187f:	5d                   	pop    %ebp
80101880:	c3                   	ret    

80101881 <readi>:
{
80101881:	f3 0f 1e fb          	endbr32 
80101885:	55                   	push   %ebp
80101886:	89 e5                	mov    %esp,%ebp
80101888:	57                   	push   %edi
80101889:	56                   	push   %esi
8010188a:	53                   	push   %ebx
8010188b:	83 ec 1c             	sub    $0x1c,%esp
8010188e:	8b 75 10             	mov    0x10(%ebp),%esi
  if(ip->type == T_DEV){
80101891:	8b 45 08             	mov    0x8(%ebp),%eax
80101894:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101899:	74 2c                	je     801018c7 <readi+0x46>
  if(off > ip->size || off + n < off)
8010189b:	8b 45 08             	mov    0x8(%ebp),%eax
8010189e:	8b 40 58             	mov    0x58(%eax),%eax
801018a1:	39 f0                	cmp    %esi,%eax
801018a3:	0f 82 cb 00 00 00    	jb     80101974 <readi+0xf3>
801018a9:	89 f2                	mov    %esi,%edx
801018ab:	03 55 14             	add    0x14(%ebp),%edx
801018ae:	0f 82 c7 00 00 00    	jb     8010197b <readi+0xfa>
  if(off + n > ip->size)
801018b4:	39 d0                	cmp    %edx,%eax
801018b6:	73 05                	jae    801018bd <readi+0x3c>
    n = ip->size - off;
801018b8:	29 f0                	sub    %esi,%eax
801018ba:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801018bd:	bf 00 00 00 00       	mov    $0x0,%edi
801018c2:	e9 8f 00 00 00       	jmp    80101956 <readi+0xd5>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801018c7:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801018cb:	66 83 f8 09          	cmp    $0x9,%ax
801018cf:	0f 87 91 00 00 00    	ja     80101966 <readi+0xe5>
801018d5:	98                   	cwtl   
801018d6:	8b 04 c5 40 41 11 80 	mov    -0x7feebec0(,%eax,8),%eax
801018dd:	85 c0                	test   %eax,%eax
801018df:	0f 84 88 00 00 00    	je     8010196d <readi+0xec>
    return devsw[ip->major].read(ip, dst, n);
801018e5:	83 ec 04             	sub    $0x4,%esp
801018e8:	ff 75 14             	pushl  0x14(%ebp)
801018eb:	ff 75 0c             	pushl  0xc(%ebp)
801018ee:	ff 75 08             	pushl  0x8(%ebp)
801018f1:	ff d0                	call   *%eax
801018f3:	83 c4 10             	add    $0x10,%esp
801018f6:	eb 66                	jmp    8010195e <readi+0xdd>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801018f8:	89 f2                	mov    %esi,%edx
801018fa:	c1 ea 09             	shr    $0x9,%edx
801018fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101900:	e8 be f8 ff ff       	call   801011c3 <bmap>
80101905:	83 ec 08             	sub    $0x8,%esp
80101908:	50                   	push   %eax
80101909:	8b 45 08             	mov    0x8(%ebp),%eax
8010190c:	ff 30                	pushl  (%eax)
8010190e:	e8 5d e8 ff ff       	call   80100170 <bread>
80101913:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
80101915:	89 f0                	mov    %esi,%eax
80101917:	25 ff 01 00 00       	and    $0x1ff,%eax
8010191c:	bb 00 02 00 00       	mov    $0x200,%ebx
80101921:	29 c3                	sub    %eax,%ebx
80101923:	8b 55 14             	mov    0x14(%ebp),%edx
80101926:	29 fa                	sub    %edi,%edx
80101928:	83 c4 0c             	add    $0xc,%esp
8010192b:	39 d3                	cmp    %edx,%ebx
8010192d:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101930:	53                   	push   %ebx
80101931:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101934:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101938:	50                   	push   %eax
80101939:	ff 75 0c             	pushl  0xc(%ebp)
8010193c:	e8 8e 38 00 00       	call   801051cf <memmove>
    brelse(bp);
80101941:	83 c4 04             	add    $0x4,%esp
80101944:	ff 75 e4             	pushl  -0x1c(%ebp)
80101947:	e8 95 e8 ff ff       	call   801001e1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010194c:	01 df                	add    %ebx,%edi
8010194e:	01 de                	add    %ebx,%esi
80101950:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101953:	83 c4 10             	add    $0x10,%esp
80101956:	39 7d 14             	cmp    %edi,0x14(%ebp)
80101959:	77 9d                	ja     801018f8 <readi+0x77>
  return n;
8010195b:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010195e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101961:	5b                   	pop    %ebx
80101962:	5e                   	pop    %esi
80101963:	5f                   	pop    %edi
80101964:	5d                   	pop    %ebp
80101965:	c3                   	ret    
      return -1;
80101966:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010196b:	eb f1                	jmp    8010195e <readi+0xdd>
8010196d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101972:	eb ea                	jmp    8010195e <readi+0xdd>
    return -1;
80101974:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101979:	eb e3                	jmp    8010195e <readi+0xdd>
8010197b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101980:	eb dc                	jmp    8010195e <readi+0xdd>

80101982 <writei>:
{
80101982:	f3 0f 1e fb          	endbr32 
80101986:	55                   	push   %ebp
80101987:	89 e5                	mov    %esp,%ebp
80101989:	57                   	push   %edi
8010198a:	56                   	push   %esi
8010198b:	53                   	push   %ebx
8010198c:	83 ec 1c             	sub    $0x1c,%esp
8010198f:	8b 75 10             	mov    0x10(%ebp),%esi
  if(ip->type == T_DEV){
80101992:	8b 45 08             	mov    0x8(%ebp),%eax
80101995:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010199a:	0f 84 9b 00 00 00    	je     80101a3b <writei+0xb9>
  if(off > ip->size || off + n < off)
801019a0:	8b 45 08             	mov    0x8(%ebp),%eax
801019a3:	39 70 58             	cmp    %esi,0x58(%eax)
801019a6:	0f 82 f0 00 00 00    	jb     80101a9c <writei+0x11a>
801019ac:	89 f0                	mov    %esi,%eax
801019ae:	03 45 14             	add    0x14(%ebp),%eax
801019b1:	0f 82 ec 00 00 00    	jb     80101aa3 <writei+0x121>
  if(off + n > MAXFILE*BSIZE)
801019b7:	3d 00 18 01 00       	cmp    $0x11800,%eax
801019bc:	0f 87 e8 00 00 00    	ja     80101aaa <writei+0x128>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801019c2:	bf 00 00 00 00       	mov    $0x0,%edi
801019c7:	3b 7d 14             	cmp    0x14(%ebp),%edi
801019ca:	0f 83 94 00 00 00    	jae    80101a64 <writei+0xe2>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	89 f2                	mov    %esi,%edx
801019d2:	c1 ea 09             	shr    $0x9,%edx
801019d5:	8b 45 08             	mov    0x8(%ebp),%eax
801019d8:	e8 e6 f7 ff ff       	call   801011c3 <bmap>
801019dd:	83 ec 08             	sub    $0x8,%esp
801019e0:	50                   	push   %eax
801019e1:	8b 45 08             	mov    0x8(%ebp),%eax
801019e4:	ff 30                	pushl  (%eax)
801019e6:	e8 85 e7 ff ff       	call   80100170 <bread>
801019eb:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ed:	89 f0                	mov    %esi,%eax
801019ef:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f4:	bb 00 02 00 00       	mov    $0x200,%ebx
801019f9:	29 c3                	sub    %eax,%ebx
801019fb:	8b 55 14             	mov    0x14(%ebp),%edx
801019fe:	29 fa                	sub    %edi,%edx
80101a00:	83 c4 0c             	add    $0xc,%esp
80101a03:	39 d3                	cmp    %edx,%ebx
80101a05:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101a08:	53                   	push   %ebx
80101a09:	ff 75 0c             	pushl  0xc(%ebp)
80101a0c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101a0f:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101a13:	50                   	push   %eax
80101a14:	e8 b6 37 00 00       	call   801051cf <memmove>
    log_write(bp);
80101a19:	83 c4 04             	add    $0x4,%esp
80101a1c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a1f:	e8 0d 10 00 00       	call   80102a31 <log_write>
    brelse(bp);
80101a24:	83 c4 04             	add    $0x4,%esp
80101a27:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a2a:	e8 b2 e7 ff ff       	call   801001e1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a2f:	01 df                	add    %ebx,%edi
80101a31:	01 de                	add    %ebx,%esi
80101a33:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101a36:	83 c4 10             	add    $0x10,%esp
80101a39:	eb 8c                	jmp    801019c7 <writei+0x45>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101a3b:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101a3f:	66 83 f8 09          	cmp    $0x9,%ax
80101a43:	77 49                	ja     80101a8e <writei+0x10c>
80101a45:	98                   	cwtl   
80101a46:	8b 04 c5 44 41 11 80 	mov    -0x7feebebc(,%eax,8),%eax
80101a4d:	85 c0                	test   %eax,%eax
80101a4f:	74 44                	je     80101a95 <writei+0x113>
    return devsw[ip->major].write(ip, src, n);
80101a51:	83 ec 04             	sub    $0x4,%esp
80101a54:	ff 75 14             	pushl  0x14(%ebp)
80101a57:	ff 75 0c             	pushl  0xc(%ebp)
80101a5a:	ff 75 08             	pushl  0x8(%ebp)
80101a5d:	ff d0                	call   *%eax
80101a5f:	83 c4 10             	add    $0x10,%esp
80101a62:	eb 11                	jmp    80101a75 <writei+0xf3>
  if(n > 0 && off > ip->size){
80101a64:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101a68:	74 08                	je     80101a72 <writei+0xf0>
80101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6d:	39 70 58             	cmp    %esi,0x58(%eax)
80101a70:	72 0b                	jb     80101a7d <writei+0xfb>
  return n;
80101a72:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101a75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a78:	5b                   	pop    %ebx
80101a79:	5e                   	pop    %esi
80101a7a:	5f                   	pop    %edi
80101a7b:	5d                   	pop    %ebp
80101a7c:	c3                   	ret    
    ip->size = off;
80101a7d:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101a80:	83 ec 0c             	sub    $0xc,%esp
80101a83:	50                   	push   %eax
80101a84:	e8 89 fa ff ff       	call   80101512 <iupdate>
80101a89:	83 c4 10             	add    $0x10,%esp
80101a8c:	eb e4                	jmp    80101a72 <writei+0xf0>
      return -1;
80101a8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a93:	eb e0                	jmp    80101a75 <writei+0xf3>
80101a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a9a:	eb d9                	jmp    80101a75 <writei+0xf3>
    return -1;
80101a9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101aa1:	eb d2                	jmp    80101a75 <writei+0xf3>
80101aa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101aa8:	eb cb                	jmp    80101a75 <writei+0xf3>
    return -1;
80101aaa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101aaf:	eb c4                	jmp    80101a75 <writei+0xf3>

80101ab1 <namecmp>:
{
80101ab1:	f3 0f 1e fb          	endbr32 
80101ab5:	55                   	push   %ebp
80101ab6:	89 e5                	mov    %esp,%ebp
80101ab8:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101abb:	6a 0e                	push   $0xe
80101abd:	ff 75 0c             	pushl  0xc(%ebp)
80101ac0:	ff 75 08             	pushl  0x8(%ebp)
80101ac3:	e8 79 37 00 00       	call   80105241 <strncmp>
}
80101ac8:	c9                   	leave  
80101ac9:	c3                   	ret    

80101aca <dirlookup>:
{
80101aca:	f3 0f 1e fb          	endbr32 
80101ace:	55                   	push   %ebp
80101acf:	89 e5                	mov    %esp,%ebp
80101ad1:	57                   	push   %edi
80101ad2:	56                   	push   %esi
80101ad3:	53                   	push   %ebx
80101ad4:	83 ec 1c             	sub    $0x1c,%esp
80101ad7:	8b 75 08             	mov    0x8(%ebp),%esi
80101ada:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
80101add:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ae2:	75 07                	jne    80101aeb <dirlookup+0x21>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ae4:	bb 00 00 00 00       	mov    $0x0,%ebx
80101ae9:	eb 1d                	jmp    80101b08 <dirlookup+0x3e>
    panic("dirlookup not DIR");
80101aeb:	83 ec 0c             	sub    $0xc,%esp
80101aee:	68 3b 7d 10 80       	push   $0x80107d3b
80101af3:	e8 64 e8 ff ff       	call   8010035c <panic>
      panic("dirlookup read");
80101af8:	83 ec 0c             	sub    $0xc,%esp
80101afb:	68 4d 7d 10 80       	push   $0x80107d4d
80101b00:	e8 57 e8 ff ff       	call   8010035c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b05:	83 c3 10             	add    $0x10,%ebx
80101b08:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101b0b:	76 48                	jbe    80101b55 <dirlookup+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b0d:	6a 10                	push   $0x10
80101b0f:	53                   	push   %ebx
80101b10:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101b13:	50                   	push   %eax
80101b14:	56                   	push   %esi
80101b15:	e8 67 fd ff ff       	call   80101881 <readi>
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	83 f8 10             	cmp    $0x10,%eax
80101b20:	75 d6                	jne    80101af8 <dirlookup+0x2e>
    if(de.inum == 0)
80101b22:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101b27:	74 dc                	je     80101b05 <dirlookup+0x3b>
    if(namecmp(name, de.name) == 0){
80101b29:	83 ec 08             	sub    $0x8,%esp
80101b2c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b2f:	50                   	push   %eax
80101b30:	57                   	push   %edi
80101b31:	e8 7b ff ff ff       	call   80101ab1 <namecmp>
80101b36:	83 c4 10             	add    $0x10,%esp
80101b39:	85 c0                	test   %eax,%eax
80101b3b:	75 c8                	jne    80101b05 <dirlookup+0x3b>
      if(poff)
80101b3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101b41:	74 05                	je     80101b48 <dirlookup+0x7e>
        *poff = off;
80101b43:	8b 45 10             	mov    0x10(%ebp),%eax
80101b46:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101b48:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101b4c:	8b 06                	mov    (%esi),%eax
80101b4e:	e8 16 f7 ff ff       	call   80101269 <iget>
80101b53:	eb 05                	jmp    80101b5a <dirlookup+0x90>
  return 0;
80101b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101b5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5d:	5b                   	pop    %ebx
80101b5e:	5e                   	pop    %esi
80101b5f:	5f                   	pop    %edi
80101b60:	5d                   	pop    %ebp
80101b61:	c3                   	ret    

80101b62 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101b62:	55                   	push   %ebp
80101b63:	89 e5                	mov    %esp,%ebp
80101b65:	57                   	push   %edi
80101b66:	56                   	push   %esi
80101b67:	53                   	push   %ebx
80101b68:	83 ec 1c             	sub    $0x1c,%esp
80101b6b:	89 c3                	mov    %eax,%ebx
80101b6d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101b70:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101b73:	80 38 2f             	cmpb   $0x2f,(%eax)
80101b76:	74 17                	je     80101b8f <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101b78:	e8 0b 1d 00 00       	call   80103888 <myproc>
80101b7d:	83 ec 0c             	sub    $0xc,%esp
80101b80:	ff 70 68             	pushl  0x68(%eax)
80101b83:	e8 bf fa ff ff       	call   80101647 <idup>
80101b88:	89 c6                	mov    %eax,%esi
80101b8a:	83 c4 10             	add    $0x10,%esp
80101b8d:	eb 53                	jmp    80101be2 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101b8f:	ba 01 00 00 00       	mov    $0x1,%edx
80101b94:	b8 01 00 00 00       	mov    $0x1,%eax
80101b99:	e8 cb f6 ff ff       	call   80101269 <iget>
80101b9e:	89 c6                	mov    %eax,%esi
80101ba0:	eb 40                	jmp    80101be2 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101ba2:	83 ec 0c             	sub    $0xc,%esp
80101ba5:	56                   	push   %esi
80101ba6:	e8 83 fc ff ff       	call   8010182e <iunlockput>
      return 0;
80101bab:	83 c4 10             	add    $0x10,%esp
80101bae:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101bb3:	89 f0                	mov    %esi,%eax
80101bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bb8:	5b                   	pop    %ebx
80101bb9:	5e                   	pop    %esi
80101bba:	5f                   	pop    %edi
80101bbb:	5d                   	pop    %ebp
80101bbc:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101bbd:	83 ec 04             	sub    $0x4,%esp
80101bc0:	6a 00                	push   $0x0
80101bc2:	ff 75 e4             	pushl  -0x1c(%ebp)
80101bc5:	56                   	push   %esi
80101bc6:	e8 ff fe ff ff       	call   80101aca <dirlookup>
80101bcb:	89 c7                	mov    %eax,%edi
80101bcd:	83 c4 10             	add    $0x10,%esp
80101bd0:	85 c0                	test   %eax,%eax
80101bd2:	74 4a                	je     80101c1e <namex+0xbc>
    iunlockput(ip);
80101bd4:	83 ec 0c             	sub    $0xc,%esp
80101bd7:	56                   	push   %esi
80101bd8:	e8 51 fc ff ff       	call   8010182e <iunlockput>
80101bdd:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101be0:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101be2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101be5:	89 d8                	mov    %ebx,%eax
80101be7:	e8 3b f4 ff ff       	call   80101027 <skipelem>
80101bec:	89 c3                	mov    %eax,%ebx
80101bee:	85 c0                	test   %eax,%eax
80101bf0:	74 3c                	je     80101c2e <namex+0xcc>
    ilock(ip);
80101bf2:	83 ec 0c             	sub    $0xc,%esp
80101bf5:	56                   	push   %esi
80101bf6:	e8 80 fa ff ff       	call   8010167b <ilock>
    if(ip->type != T_DIR){
80101bfb:	83 c4 10             	add    $0x10,%esp
80101bfe:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101c03:	75 9d                	jne    80101ba2 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101c05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101c09:	74 b2                	je     80101bbd <namex+0x5b>
80101c0b:	80 3b 00             	cmpb   $0x0,(%ebx)
80101c0e:	75 ad                	jne    80101bbd <namex+0x5b>
      iunlock(ip);
80101c10:	83 ec 0c             	sub    $0xc,%esp
80101c13:	56                   	push   %esi
80101c14:	e8 28 fb ff ff       	call   80101741 <iunlock>
      return ip;
80101c19:	83 c4 10             	add    $0x10,%esp
80101c1c:	eb 95                	jmp    80101bb3 <namex+0x51>
      iunlockput(ip);
80101c1e:	83 ec 0c             	sub    $0xc,%esp
80101c21:	56                   	push   %esi
80101c22:	e8 07 fc ff ff       	call   8010182e <iunlockput>
      return 0;
80101c27:	83 c4 10             	add    $0x10,%esp
80101c2a:	89 fe                	mov    %edi,%esi
80101c2c:	eb 85                	jmp    80101bb3 <namex+0x51>
  if(nameiparent){
80101c2e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101c32:	0f 84 7b ff ff ff    	je     80101bb3 <namex+0x51>
    iput(ip);
80101c38:	83 ec 0c             	sub    $0xc,%esp
80101c3b:	56                   	push   %esi
80101c3c:	e8 49 fb ff ff       	call   8010178a <iput>
    return 0;
80101c41:	83 c4 10             	add    $0x10,%esp
80101c44:	89 de                	mov    %ebx,%esi
80101c46:	e9 68 ff ff ff       	jmp    80101bb3 <namex+0x51>

80101c4b <dirlink>:
{
80101c4b:	f3 0f 1e fb          	endbr32 
80101c4f:	55                   	push   %ebp
80101c50:	89 e5                	mov    %esp,%ebp
80101c52:	57                   	push   %edi
80101c53:	56                   	push   %esi
80101c54:	53                   	push   %ebx
80101c55:	83 ec 20             	sub    $0x20,%esp
80101c58:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101c5b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101c5e:	6a 00                	push   $0x0
80101c60:	57                   	push   %edi
80101c61:	53                   	push   %ebx
80101c62:	e8 63 fe ff ff       	call   80101aca <dirlookup>
80101c67:	83 c4 10             	add    $0x10,%esp
80101c6a:	85 c0                	test   %eax,%eax
80101c6c:	75 07                	jne    80101c75 <dirlink+0x2a>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c6e:	b8 00 00 00 00       	mov    $0x0,%eax
80101c73:	eb 23                	jmp    80101c98 <dirlink+0x4d>
    iput(ip);
80101c75:	83 ec 0c             	sub    $0xc,%esp
80101c78:	50                   	push   %eax
80101c79:	e8 0c fb ff ff       	call   8010178a <iput>
    return -1;
80101c7e:	83 c4 10             	add    $0x10,%esp
80101c81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c86:	eb 63                	jmp    80101ceb <dirlink+0xa0>
      panic("dirlink read");
80101c88:	83 ec 0c             	sub    $0xc,%esp
80101c8b:	68 5c 7d 10 80       	push   $0x80107d5c
80101c90:	e8 c7 e6 ff ff       	call   8010035c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c95:	8d 46 10             	lea    0x10(%esi),%eax
80101c98:	89 c6                	mov    %eax,%esi
80101c9a:	39 43 58             	cmp    %eax,0x58(%ebx)
80101c9d:	76 1c                	jbe    80101cbb <dirlink+0x70>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c9f:	6a 10                	push   $0x10
80101ca1:	50                   	push   %eax
80101ca2:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101ca5:	50                   	push   %eax
80101ca6:	53                   	push   %ebx
80101ca7:	e8 d5 fb ff ff       	call   80101881 <readi>
80101cac:	83 c4 10             	add    $0x10,%esp
80101caf:	83 f8 10             	cmp    $0x10,%eax
80101cb2:	75 d4                	jne    80101c88 <dirlink+0x3d>
    if(de.inum == 0)
80101cb4:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cb9:	75 da                	jne    80101c95 <dirlink+0x4a>
  strncpy(de.name, name, DIRSIZ);
80101cbb:	83 ec 04             	sub    $0x4,%esp
80101cbe:	6a 0e                	push   $0xe
80101cc0:	57                   	push   %edi
80101cc1:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101cc4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cc7:	50                   	push   %eax
80101cc8:	e8 b5 35 00 00       	call   80105282 <strncpy>
  de.inum = inum;
80101ccd:	8b 45 10             	mov    0x10(%ebp),%eax
80101cd0:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cd4:	6a 10                	push   $0x10
80101cd6:	56                   	push   %esi
80101cd7:	57                   	push   %edi
80101cd8:	53                   	push   %ebx
80101cd9:	e8 a4 fc ff ff       	call   80101982 <writei>
80101cde:	83 c4 20             	add    $0x20,%esp
80101ce1:	83 f8 10             	cmp    $0x10,%eax
80101ce4:	75 0d                	jne    80101cf3 <dirlink+0xa8>
  return 0;
80101ce6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cee:	5b                   	pop    %ebx
80101cef:	5e                   	pop    %esi
80101cf0:	5f                   	pop    %edi
80101cf1:	5d                   	pop    %ebp
80101cf2:	c3                   	ret    
    panic("dirlink");
80101cf3:	83 ec 0c             	sub    $0xc,%esp
80101cf6:	68 78 8a 10 80       	push   $0x80108a78
80101cfb:	e8 5c e6 ff ff       	call   8010035c <panic>

80101d00 <namei>:

struct inode*
namei(char *path)
{
80101d00:	f3 0f 1e fb          	endbr32 
80101d04:	55                   	push   %ebp
80101d05:	89 e5                	mov    %esp,%ebp
80101d07:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101d0a:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101d0d:	ba 00 00 00 00       	mov    $0x0,%edx
80101d12:	8b 45 08             	mov    0x8(%ebp),%eax
80101d15:	e8 48 fe ff ff       	call   80101b62 <namex>
}
80101d1a:	c9                   	leave  
80101d1b:	c3                   	ret    

80101d1c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101d1c:	f3 0f 1e fb          	endbr32 
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101d26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101d29:	ba 01 00 00 00       	mov    $0x1,%edx
80101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d31:	e8 2c fe ff ff       	call   80101b62 <namex>
}
80101d36:	c9                   	leave  
80101d37:	c3                   	ret    

80101d38 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101d38:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d3a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d3f:	ec                   	in     (%dx),%al
80101d40:	89 c2                	mov    %eax,%edx
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101d42:	83 e0 c0             	and    $0xffffffc0,%eax
80101d45:	3c 40                	cmp    $0x40,%al
80101d47:	75 f1                	jne    80101d3a <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101d49:	85 c9                	test   %ecx,%ecx
80101d4b:	74 0a                	je     80101d57 <idewait+0x1f>
80101d4d:	f6 c2 21             	test   $0x21,%dl
80101d50:	75 08                	jne    80101d5a <idewait+0x22>
    return -1;
  return 0;
80101d52:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101d57:	89 c8                	mov    %ecx,%eax
80101d59:	c3                   	ret    
    return -1;
80101d5a:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101d5f:	eb f6                	jmp    80101d57 <idewait+0x1f>

80101d61 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101d61:	55                   	push   %ebp
80101d62:	89 e5                	mov    %esp,%ebp
80101d64:	56                   	push   %esi
80101d65:	53                   	push   %ebx
  if(b == 0)
80101d66:	85 c0                	test   %eax,%eax
80101d68:	0f 84 91 00 00 00    	je     80101dff <idestart+0x9e>
80101d6e:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101d70:	8b 58 08             	mov    0x8(%eax),%ebx
80101d73:	81 fb cf 07 00 00    	cmp    $0x7cf,%ebx
80101d79:	0f 87 8d 00 00 00    	ja     80101e0c <idestart+0xab>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101d7f:	b8 00 00 00 00       	mov    $0x0,%eax
80101d84:	e8 af ff ff ff       	call   80101d38 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d89:	b8 00 00 00 00       	mov    $0x0,%eax
80101d8e:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101d93:	ee                   	out    %al,(%dx)
80101d94:	b8 01 00 00 00       	mov    $0x1,%eax
80101d99:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101d9e:	ee                   	out    %al,(%dx)
80101d9f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101da4:	89 d8                	mov    %ebx,%eax
80101da6:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101da7:	89 d8                	mov    %ebx,%eax
80101da9:	c1 f8 08             	sar    $0x8,%eax
80101dac:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101db1:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101db2:	89 d8                	mov    %ebx,%eax
80101db4:	c1 f8 10             	sar    $0x10,%eax
80101db7:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101dbc:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101dbd:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101dc1:	c1 e0 04             	shl    $0x4,%eax
80101dc4:	83 e0 10             	and    $0x10,%eax
80101dc7:	c1 fb 18             	sar    $0x18,%ebx
80101dca:	83 e3 0f             	and    $0xf,%ebx
80101dcd:	09 d8                	or     %ebx,%eax
80101dcf:	83 c8 e0             	or     $0xffffffe0,%eax
80101dd2:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101dd7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101dd8:	f6 06 04             	testb  $0x4,(%esi)
80101ddb:	74 3c                	je     80101e19 <idestart+0xb8>
80101ddd:	b8 30 00 00 00       	mov    $0x30,%eax
80101de2:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101de7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101de8:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101deb:	b9 80 00 00 00       	mov    $0x80,%ecx
80101df0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101df5:	fc                   	cld    
80101df6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101df8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5d                   	pop    %ebp
80101dfe:	c3                   	ret    
    panic("idestart");
80101dff:	83 ec 0c             	sub    $0xc,%esp
80101e02:	68 bf 7d 10 80       	push   $0x80107dbf
80101e07:	e8 50 e5 ff ff       	call   8010035c <panic>
    panic("incorrect blockno");
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	68 c8 7d 10 80       	push   $0x80107dc8
80101e14:	e8 43 e5 ff ff       	call   8010035c <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e19:	b8 20 00 00 00       	mov    $0x20,%eax
80101e1e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e23:	ee                   	out    %al,(%dx)
}
80101e24:	eb d2                	jmp    80101df8 <idestart+0x97>

80101e26 <ideinit>:
{
80101e26:	f3 0f 1e fb          	endbr32 
80101e2a:	55                   	push   %ebp
80101e2b:	89 e5                	mov    %esp,%ebp
80101e2d:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101e30:	68 da 7d 10 80       	push   $0x80107dda
80101e35:	68 80 b5 10 80       	push   $0x8010b580
80101e3a:	e8 0c 31 00 00       	call   80104f4b <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101e3f:	83 c4 08             	add    $0x8,%esp
80101e42:	a1 e0 64 11 80       	mov    0x801164e0,%eax
80101e47:	83 e8 01             	sub    $0x1,%eax
80101e4a:	50                   	push   %eax
80101e4b:	6a 0e                	push   $0xe
80101e4d:	e8 5a 02 00 00       	call   801020ac <ioapicenable>
  idewait(0);
80101e52:	b8 00 00 00 00       	mov    $0x0,%eax
80101e57:	e8 dc fe ff ff       	call   80101d38 <idewait>
80101e5c:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101e61:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e66:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101e67:	83 c4 10             	add    $0x10,%esp
80101e6a:	b9 00 00 00 00       	mov    $0x0,%ecx
80101e6f:	eb 03                	jmp    80101e74 <ideinit+0x4e>
80101e71:	83 c1 01             	add    $0x1,%ecx
80101e74:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101e7a:	7f 14                	jg     80101e90 <ideinit+0x6a>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e7c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e81:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101e82:	84 c0                	test   %al,%al
80101e84:	74 eb                	je     80101e71 <ideinit+0x4b>
      havedisk1 = 1;
80101e86:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80101e8d:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e90:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101e95:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e9a:	ee                   	out    %al,(%dx)
}
80101e9b:	c9                   	leave  
80101e9c:	c3                   	ret    

80101e9d <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101e9d:	f3 0f 1e fb          	endbr32 
80101ea1:	55                   	push   %ebp
80101ea2:	89 e5                	mov    %esp,%ebp
80101ea4:	57                   	push   %edi
80101ea5:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101ea6:	83 ec 0c             	sub    $0xc,%esp
80101ea9:	68 80 b5 10 80       	push   $0x8010b580
80101eae:	e8 e8 31 00 00       	call   8010509b <acquire>

  if((b = idequeue) == 0){
80101eb3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80101eb9:	83 c4 10             	add    $0x10,%esp
80101ebc:	85 db                	test   %ebx,%ebx
80101ebe:	74 48                	je     80101f08 <ideintr+0x6b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101ec0:	8b 43 58             	mov    0x58(%ebx),%eax
80101ec3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101ec8:	f6 03 04             	testb  $0x4,(%ebx)
80101ecb:	74 4d                	je     80101f1a <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101ecd:	8b 03                	mov    (%ebx),%eax
80101ecf:	83 c8 02             	or     $0x2,%eax
  b->flags &= ~B_DIRTY;
80101ed2:	83 e0 fb             	and    $0xfffffffb,%eax
80101ed5:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101ed7:	83 ec 0c             	sub    $0xc,%esp
80101eda:	53                   	push   %ebx
80101edb:	e8 00 25 00 00       	call   801043e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101ee0:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80101ee5:	83 c4 10             	add    $0x10,%esp
80101ee8:	85 c0                	test   %eax,%eax
80101eea:	74 05                	je     80101ef1 <ideintr+0x54>
    idestart(idequeue);
80101eec:	e8 70 fe ff ff       	call   80101d61 <idestart>

  release(&idelock);
80101ef1:	83 ec 0c             	sub    $0xc,%esp
80101ef4:	68 80 b5 10 80       	push   $0x8010b580
80101ef9:	e8 06 32 00 00       	call   80105104 <release>
80101efe:	83 c4 10             	add    $0x10,%esp
}
80101f01:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f04:	5b                   	pop    %ebx
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
    release(&idelock);
80101f08:	83 ec 0c             	sub    $0xc,%esp
80101f0b:	68 80 b5 10 80       	push   $0x8010b580
80101f10:	e8 ef 31 00 00       	call   80105104 <release>
    return;
80101f15:	83 c4 10             	add    $0x10,%esp
80101f18:	eb e7                	jmp    80101f01 <ideintr+0x64>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101f1a:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1f:	e8 14 fe ff ff       	call   80101d38 <idewait>
80101f24:	85 c0                	test   %eax,%eax
80101f26:	78 a5                	js     80101ecd <ideintr+0x30>
    insl(0x1f0, b->data, BSIZE/4);
80101f28:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101f2b:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f30:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101f35:	fc                   	cld    
80101f36:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101f38:	eb 93                	jmp    80101ecd <ideintr+0x30>

80101f3a <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101f3a:	f3 0f 1e fb          	endbr32 
80101f3e:	55                   	push   %ebp
80101f3f:	89 e5                	mov    %esp,%ebp
80101f41:	53                   	push   %ebx
80101f42:	83 ec 10             	sub    $0x10,%esp
80101f45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101f48:	8d 43 0c             	lea    0xc(%ebx),%eax
80101f4b:	50                   	push   %eax
80101f4c:	e8 cf 2f 00 00       	call   80104f20 <holdingsleep>
80101f51:	83 c4 10             	add    $0x10,%esp
80101f54:	85 c0                	test   %eax,%eax
80101f56:	74 37                	je     80101f8f <iderw+0x55>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101f58:	8b 03                	mov    (%ebx),%eax
80101f5a:	83 e0 06             	and    $0x6,%eax
80101f5d:	83 f8 02             	cmp    $0x2,%eax
80101f60:	74 3a                	je     80101f9c <iderw+0x62>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101f62:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101f66:	74 09                	je     80101f71 <iderw+0x37>
80101f68:	83 3d 60 b5 10 80 00 	cmpl   $0x0,0x8010b560
80101f6f:	74 38                	je     80101fa9 <iderw+0x6f>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101f71:	83 ec 0c             	sub    $0xc,%esp
80101f74:	68 80 b5 10 80       	push   $0x8010b580
80101f79:	e8 1d 31 00 00       	call   8010509b <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101f7e:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f85:	83 c4 10             	add    $0x10,%esp
80101f88:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80101f8d:	eb 2a                	jmp    80101fb9 <iderw+0x7f>
    panic("iderw: buf not locked");
80101f8f:	83 ec 0c             	sub    $0xc,%esp
80101f92:	68 de 7d 10 80       	push   $0x80107dde
80101f97:	e8 c0 e3 ff ff       	call   8010035c <panic>
    panic("iderw: nothing to do");
80101f9c:	83 ec 0c             	sub    $0xc,%esp
80101f9f:	68 f4 7d 10 80       	push   $0x80107df4
80101fa4:	e8 b3 e3 ff ff       	call   8010035c <panic>
    panic("iderw: ide disk 1 not present");
80101fa9:	83 ec 0c             	sub    $0xc,%esp
80101fac:	68 09 7e 10 80       	push   $0x80107e09
80101fb1:	e8 a6 e3 ff ff       	call   8010035c <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101fb6:	8d 50 58             	lea    0x58(%eax),%edx
80101fb9:	8b 02                	mov    (%edx),%eax
80101fbb:	85 c0                	test   %eax,%eax
80101fbd:	75 f7                	jne    80101fb6 <iderw+0x7c>
    ;
  *pp = b;
80101fbf:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101fc1:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
80101fc7:	75 1a                	jne    80101fe3 <iderw+0xa9>
    idestart(b);
80101fc9:	89 d8                	mov    %ebx,%eax
80101fcb:	e8 91 fd ff ff       	call   80101d61 <idestart>
80101fd0:	eb 11                	jmp    80101fe3 <iderw+0xa9>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101fd2:	83 ec 08             	sub    $0x8,%esp
80101fd5:	68 80 b5 10 80       	push   $0x8010b580
80101fda:	53                   	push   %ebx
80101fdb:	e8 01 21 00 00       	call   801040e1 <sleep>
80101fe0:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101fe3:	8b 03                	mov    (%ebx),%eax
80101fe5:	83 e0 06             	and    $0x6,%eax
80101fe8:	83 f8 02             	cmp    $0x2,%eax
80101feb:	75 e5                	jne    80101fd2 <iderw+0x98>
  }


  release(&idelock);
80101fed:	83 ec 0c             	sub    $0xc,%esp
80101ff0:	68 80 b5 10 80       	push   $0x8010b580
80101ff5:	e8 0a 31 00 00       	call   80105104 <release>
}
80101ffa:	83 c4 10             	add    $0x10,%esp
80101ffd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102000:	c9                   	leave  
80102001:	c3                   	ret    

80102002 <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102002:	8b 15 14 5e 11 80    	mov    0x80115e14,%edx
80102008:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
8010200a:	a1 14 5e 11 80       	mov    0x80115e14,%eax
8010200f:	8b 40 10             	mov    0x10(%eax),%eax
}
80102012:	c3                   	ret    

80102013 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102013:	8b 0d 14 5e 11 80    	mov    0x80115e14,%ecx
80102019:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010201b:	a1 14 5e 11 80       	mov    0x80115e14,%eax
80102020:	89 50 10             	mov    %edx,0x10(%eax)
}
80102023:	c3                   	ret    

80102024 <ioapicinit>:

void
ioapicinit(void)
{
80102024:	f3 0f 1e fb          	endbr32 
80102028:	55                   	push   %ebp
80102029:	89 e5                	mov    %esp,%ebp
8010202b:	57                   	push   %edi
8010202c:	56                   	push   %esi
8010202d:	53                   	push   %ebx
8010202e:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102031:	c7 05 14 5e 11 80 00 	movl   $0xfec00000,0x80115e14
80102038:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010203b:	b8 01 00 00 00       	mov    $0x1,%eax
80102040:	e8 bd ff ff ff       	call   80102002 <ioapicread>
80102045:	c1 e8 10             	shr    $0x10,%eax
80102048:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
8010204b:	b8 00 00 00 00       	mov    $0x0,%eax
80102050:	e8 ad ff ff ff       	call   80102002 <ioapicread>
80102055:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102058:	0f b6 15 40 5f 11 80 	movzbl 0x80115f40,%edx
8010205f:	39 c2                	cmp    %eax,%edx
80102061:	75 2f                	jne    80102092 <ioapicinit+0x6e>
{
80102063:	bb 00 00 00 00       	mov    $0x0,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102068:	39 fb                	cmp    %edi,%ebx
8010206a:	7f 38                	jg     801020a4 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010206c:	8d 53 20             	lea    0x20(%ebx),%edx
8010206f:	81 ca 00 00 01 00    	or     $0x10000,%edx
80102075:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80102079:	89 f0                	mov    %esi,%eax
8010207b:	e8 93 ff ff ff       	call   80102013 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102080:	8d 46 01             	lea    0x1(%esi),%eax
80102083:	ba 00 00 00 00       	mov    $0x0,%edx
80102088:	e8 86 ff ff ff       	call   80102013 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
8010208d:	83 c3 01             	add    $0x1,%ebx
80102090:	eb d6                	jmp    80102068 <ioapicinit+0x44>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102092:	83 ec 0c             	sub    $0xc,%esp
80102095:	68 28 7e 10 80       	push   $0x80107e28
8010209a:	e8 8a e5 ff ff       	call   80100629 <cprintf>
8010209f:	83 c4 10             	add    $0x10,%esp
801020a2:	eb bf                	jmp    80102063 <ioapicinit+0x3f>
  }
}
801020a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a7:	5b                   	pop    %ebx
801020a8:	5e                   	pop    %esi
801020a9:	5f                   	pop    %edi
801020aa:	5d                   	pop    %ebp
801020ab:	c3                   	ret    

801020ac <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801020ac:	f3 0f 1e fb          	endbr32 
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	53                   	push   %ebx
801020b4:	83 ec 04             	sub    $0x4,%esp
801020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801020ba:	8d 50 20             	lea    0x20(%eax),%edx
801020bd:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
801020c1:	89 d8                	mov    %ebx,%eax
801020c3:	e8 4b ff ff ff       	call   80102013 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801020c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801020cb:	c1 e2 18             	shl    $0x18,%edx
801020ce:	8d 43 01             	lea    0x1(%ebx),%eax
801020d1:	e8 3d ff ff ff       	call   80102013 <ioapicwrite>
}
801020d6:	83 c4 04             	add    $0x4,%esp
801020d9:	5b                   	pop    %ebx
801020da:	5d                   	pop    %ebp
801020db:	c3                   	ret    

801020dc <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801020dc:	f3 0f 1e fb          	endbr32 
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	53                   	push   %ebx
801020e4:	83 ec 04             	sub    $0x4,%esp
801020e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801020ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801020f0:	75 4c                	jne    8010213e <kfree+0x62>
801020f2:	81 fb 08 6d 11 80    	cmp    $0x80116d08,%ebx
801020f8:	72 44                	jb     8010213e <kfree+0x62>
801020fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102100:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102105:	77 37                	ja     8010213e <kfree+0x62>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102107:	83 ec 04             	sub    $0x4,%esp
8010210a:	68 00 10 00 00       	push   $0x1000
8010210f:	6a 01                	push   $0x1
80102111:	53                   	push   %ebx
80102112:	e8 38 30 00 00       	call   8010514f <memset>

  if(kmem.use_lock)
80102117:	83 c4 10             	add    $0x10,%esp
8010211a:	83 3d 54 5e 11 80 00 	cmpl   $0x0,0x80115e54
80102121:	75 28                	jne    8010214b <kfree+0x6f>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102123:	a1 58 5e 11 80       	mov    0x80115e58,%eax
80102128:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
8010212a:	89 1d 58 5e 11 80    	mov    %ebx,0x80115e58
  if(kmem.use_lock)
80102130:	83 3d 54 5e 11 80 00 	cmpl   $0x0,0x80115e54
80102137:	75 24                	jne    8010215d <kfree+0x81>
    release(&kmem.lock);
}
80102139:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010213c:	c9                   	leave  
8010213d:	c3                   	ret    
    panic("kfree");
8010213e:	83 ec 0c             	sub    $0xc,%esp
80102141:	68 5a 7e 10 80       	push   $0x80107e5a
80102146:	e8 11 e2 ff ff       	call   8010035c <panic>
    acquire(&kmem.lock);
8010214b:	83 ec 0c             	sub    $0xc,%esp
8010214e:	68 20 5e 11 80       	push   $0x80115e20
80102153:	e8 43 2f 00 00       	call   8010509b <acquire>
80102158:	83 c4 10             	add    $0x10,%esp
8010215b:	eb c6                	jmp    80102123 <kfree+0x47>
    release(&kmem.lock);
8010215d:	83 ec 0c             	sub    $0xc,%esp
80102160:	68 20 5e 11 80       	push   $0x80115e20
80102165:	e8 9a 2f 00 00       	call   80105104 <release>
8010216a:	83 c4 10             	add    $0x10,%esp
}
8010216d:	eb ca                	jmp    80102139 <kfree+0x5d>

8010216f <freerange>:
{
8010216f:	f3 0f 1e fb          	endbr32 
80102173:	55                   	push   %ebp
80102174:	89 e5                	mov    %esp,%ebp
80102176:	56                   	push   %esi
80102177:	53                   	push   %ebx
80102178:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010217b:	8b 45 08             	mov    0x8(%ebp),%eax
8010217e:	05 ff 0f 00 00       	add    $0xfff,%eax
80102183:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102188:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
8010218e:	39 de                	cmp    %ebx,%esi
80102190:	77 10                	ja     801021a2 <freerange+0x33>
    kfree(p);
80102192:	83 ec 0c             	sub    $0xc,%esp
80102195:	50                   	push   %eax
80102196:	e8 41 ff ff ff       	call   801020dc <kfree>
8010219b:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010219e:	89 f0                	mov    %esi,%eax
801021a0:	eb e6                	jmp    80102188 <freerange+0x19>
}
801021a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021a5:	5b                   	pop    %ebx
801021a6:	5e                   	pop    %esi
801021a7:	5d                   	pop    %ebp
801021a8:	c3                   	ret    

801021a9 <kinit1>:
{
801021a9:	f3 0f 1e fb          	endbr32 
801021ad:	55                   	push   %ebp
801021ae:	89 e5                	mov    %esp,%ebp
801021b0:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
801021b3:	68 60 7e 10 80       	push   $0x80107e60
801021b8:	68 20 5e 11 80       	push   $0x80115e20
801021bd:	e8 89 2d 00 00       	call   80104f4b <initlock>
  kmem.use_lock = 0;
801021c2:	c7 05 54 5e 11 80 00 	movl   $0x0,0x80115e54
801021c9:	00 00 00 
  freerange(vstart, vend);
801021cc:	83 c4 08             	add    $0x8,%esp
801021cf:	ff 75 0c             	pushl  0xc(%ebp)
801021d2:	ff 75 08             	pushl  0x8(%ebp)
801021d5:	e8 95 ff ff ff       	call   8010216f <freerange>
}
801021da:	83 c4 10             	add    $0x10,%esp
801021dd:	c9                   	leave  
801021de:	c3                   	ret    

801021df <kinit2>:
{
801021df:	f3 0f 1e fb          	endbr32 
801021e3:	55                   	push   %ebp
801021e4:	89 e5                	mov    %esp,%ebp
801021e6:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
801021e9:	ff 75 0c             	pushl  0xc(%ebp)
801021ec:	ff 75 08             	pushl  0x8(%ebp)
801021ef:	e8 7b ff ff ff       	call   8010216f <freerange>
  kmem.use_lock = 1;
801021f4:	c7 05 54 5e 11 80 01 	movl   $0x1,0x80115e54
801021fb:	00 00 00 
}
801021fe:	83 c4 10             	add    $0x10,%esp
80102201:	c9                   	leave  
80102202:	c3                   	ret    

80102203 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102203:	f3 0f 1e fb          	endbr32 
80102207:	55                   	push   %ebp
80102208:	89 e5                	mov    %esp,%ebp
8010220a:	53                   	push   %ebx
8010220b:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
8010220e:	83 3d 54 5e 11 80 00 	cmpl   $0x0,0x80115e54
80102215:	75 21                	jne    80102238 <kalloc+0x35>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102217:	8b 1d 58 5e 11 80    	mov    0x80115e58,%ebx
  if(r)
8010221d:	85 db                	test   %ebx,%ebx
8010221f:	74 07                	je     80102228 <kalloc+0x25>
    kmem.freelist = r->next;
80102221:	8b 03                	mov    (%ebx),%eax
80102223:	a3 58 5e 11 80       	mov    %eax,0x80115e58
  if(kmem.use_lock)
80102228:	83 3d 54 5e 11 80 00 	cmpl   $0x0,0x80115e54
8010222f:	75 19                	jne    8010224a <kalloc+0x47>
    release(&kmem.lock);
  return (char*)r;
}
80102231:	89 d8                	mov    %ebx,%eax
80102233:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102236:	c9                   	leave  
80102237:	c3                   	ret    
    acquire(&kmem.lock);
80102238:	83 ec 0c             	sub    $0xc,%esp
8010223b:	68 20 5e 11 80       	push   $0x80115e20
80102240:	e8 56 2e 00 00       	call   8010509b <acquire>
80102245:	83 c4 10             	add    $0x10,%esp
80102248:	eb cd                	jmp    80102217 <kalloc+0x14>
    release(&kmem.lock);
8010224a:	83 ec 0c             	sub    $0xc,%esp
8010224d:	68 20 5e 11 80       	push   $0x80115e20
80102252:	e8 ad 2e 00 00       	call   80105104 <release>
80102257:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
8010225a:	eb d5                	jmp    80102231 <kalloc+0x2e>

8010225c <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
8010225c:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102260:	ba 64 00 00 00       	mov    $0x64,%edx
80102265:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102266:	a8 01                	test   $0x1,%al
80102268:	0f 84 ad 00 00 00    	je     8010231b <kbdgetc+0xbf>
8010226e:	ba 60 00 00 00       	mov    $0x60,%edx
80102273:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102274:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102277:	3c e0                	cmp    $0xe0,%al
80102279:	74 5b                	je     801022d6 <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010227b:	84 c0                	test   %al,%al
8010227d:	78 64                	js     801022e3 <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010227f:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
80102285:	f6 c1 40             	test   $0x40,%cl
80102288:	74 0f                	je     80102299 <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010228a:	83 c8 80             	or     $0xffffff80,%eax
8010228d:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
80102290:	83 e1 bf             	and    $0xffffffbf,%ecx
80102293:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  }

  shift |= shiftcode[data];
80102299:	0f b6 8a a0 7f 10 80 	movzbl -0x7fef8060(%edx),%ecx
801022a0:	0b 0d b4 b5 10 80    	or     0x8010b5b4,%ecx
  shift ^= togglecode[data];
801022a6:	0f b6 82 a0 7e 10 80 	movzbl -0x7fef8160(%edx),%eax
801022ad:	31 c1                	xor    %eax,%ecx
801022af:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801022b5:	89 c8                	mov    %ecx,%eax
801022b7:	83 e0 03             	and    $0x3,%eax
801022ba:	8b 04 85 80 7e 10 80 	mov    -0x7fef8180(,%eax,4),%eax
801022c1:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801022c5:	f6 c1 08             	test   $0x8,%cl
801022c8:	74 56                	je     80102320 <kbdgetc+0xc4>
    if('a' <= c && c <= 'z')
801022ca:	8d 50 9f             	lea    -0x61(%eax),%edx
801022cd:	83 fa 19             	cmp    $0x19,%edx
801022d0:	77 3d                	ja     8010230f <kbdgetc+0xb3>
      c += 'A' - 'a';
801022d2:	83 e8 20             	sub    $0x20,%eax
801022d5:	c3                   	ret    
    shift |= E0ESC;
801022d6:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
    return 0;
801022dd:	b8 00 00 00 00       	mov    $0x0,%eax
801022e2:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801022e3:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
801022e9:	f6 c1 40             	test   $0x40,%cl
801022ec:	75 05                	jne    801022f3 <kbdgetc+0x97>
801022ee:	89 c2                	mov    %eax,%edx
801022f0:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801022f3:	0f b6 82 a0 7f 10 80 	movzbl -0x7fef8060(%edx),%eax
801022fa:	83 c8 40             	or     $0x40,%eax
801022fd:	0f b6 c0             	movzbl %al,%eax
80102300:	f7 d0                	not    %eax
80102302:	21 c8                	and    %ecx,%eax
80102304:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
80102309:	b8 00 00 00 00       	mov    $0x0,%eax
8010230e:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
8010230f:	8d 50 bf             	lea    -0x41(%eax),%edx
80102312:	83 fa 19             	cmp    $0x19,%edx
80102315:	77 09                	ja     80102320 <kbdgetc+0xc4>
      c += 'a' - 'A';
80102317:	83 c0 20             	add    $0x20,%eax
  }
  return c;
8010231a:	c3                   	ret    
    return -1;
8010231b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102320:	c3                   	ret    

80102321 <kbdintr>:

void
kbdintr(void)
{
80102321:	f3 0f 1e fb          	endbr32 
80102325:	55                   	push   %ebp
80102326:	89 e5                	mov    %esp,%ebp
80102328:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010232b:	68 5c 22 10 80       	push   $0x8010225c
80102330:	e8 49 e4 ff ff       	call   8010077e <consoleintr>
}
80102335:	83 c4 10             	add    $0x10,%esp
80102338:	c9                   	leave  
80102339:	c3                   	ret    

8010233a <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010233a:	8b 0d 5c 5e 11 80    	mov    0x80115e5c,%ecx
80102340:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80102343:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102345:	a1 5c 5e 11 80       	mov    0x80115e5c,%eax
8010234a:	8b 40 20             	mov    0x20(%eax),%eax
}
8010234d:	c3                   	ret    

8010234e <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010234e:	ba 70 00 00 00       	mov    $0x70,%edx
80102353:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102354:	ba 71 00 00 00       	mov    $0x71,%edx
80102359:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
8010235a:	0f b6 c0             	movzbl %al,%eax
}
8010235d:	c3                   	ret    

8010235e <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010235e:	55                   	push   %ebp
8010235f:	89 e5                	mov    %esp,%ebp
80102361:	53                   	push   %ebx
80102362:	83 ec 04             	sub    $0x4,%esp
80102365:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
80102367:	b8 00 00 00 00       	mov    $0x0,%eax
8010236c:	e8 dd ff ff ff       	call   8010234e <cmos_read>
80102371:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
80102373:	b8 02 00 00 00       	mov    $0x2,%eax
80102378:	e8 d1 ff ff ff       	call   8010234e <cmos_read>
8010237d:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
80102380:	b8 04 00 00 00       	mov    $0x4,%eax
80102385:	e8 c4 ff ff ff       	call   8010234e <cmos_read>
8010238a:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
8010238d:	b8 07 00 00 00       	mov    $0x7,%eax
80102392:	e8 b7 ff ff ff       	call   8010234e <cmos_read>
80102397:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
8010239a:	b8 08 00 00 00       	mov    $0x8,%eax
8010239f:	e8 aa ff ff ff       	call   8010234e <cmos_read>
801023a4:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
801023a7:	b8 09 00 00 00       	mov    $0x9,%eax
801023ac:	e8 9d ff ff ff       	call   8010234e <cmos_read>
801023b1:	89 43 14             	mov    %eax,0x14(%ebx)
}
801023b4:	83 c4 04             	add    $0x4,%esp
801023b7:	5b                   	pop    %ebx
801023b8:	5d                   	pop    %ebp
801023b9:	c3                   	ret    

801023ba <lapicinit>:
{
801023ba:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801023be:	83 3d 5c 5e 11 80 00 	cmpl   $0x0,0x80115e5c
801023c5:	0f 84 fe 00 00 00    	je     801024c9 <lapicinit+0x10f>
{
801023cb:	55                   	push   %ebp
801023cc:	89 e5                	mov    %esp,%ebp
801023ce:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801023d1:	ba 3f 01 00 00       	mov    $0x13f,%edx
801023d6:	b8 3c 00 00 00       	mov    $0x3c,%eax
801023db:	e8 5a ff ff ff       	call   8010233a <lapicw>
  lapicw(TDCR, X1);
801023e0:	ba 0b 00 00 00       	mov    $0xb,%edx
801023e5:	b8 f8 00 00 00       	mov    $0xf8,%eax
801023ea:	e8 4b ff ff ff       	call   8010233a <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801023ef:	ba 20 00 02 00       	mov    $0x20020,%edx
801023f4:	b8 c8 00 00 00       	mov    $0xc8,%eax
801023f9:	e8 3c ff ff ff       	call   8010233a <lapicw>
  lapicw(TICR, 1000000);
801023fe:	ba 40 42 0f 00       	mov    $0xf4240,%edx
80102403:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102408:	e8 2d ff ff ff       	call   8010233a <lapicw>
  lapicw(LINT0, MASKED);
8010240d:	ba 00 00 01 00       	mov    $0x10000,%edx
80102412:	b8 d4 00 00 00       	mov    $0xd4,%eax
80102417:	e8 1e ff ff ff       	call   8010233a <lapicw>
  lapicw(LINT1, MASKED);
8010241c:	ba 00 00 01 00       	mov    $0x10000,%edx
80102421:	b8 d8 00 00 00       	mov    $0xd8,%eax
80102426:	e8 0f ff ff ff       	call   8010233a <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010242b:	a1 5c 5e 11 80       	mov    0x80115e5c,%eax
80102430:	8b 40 30             	mov    0x30(%eax),%eax
80102433:	c1 e8 10             	shr    $0x10,%eax
80102436:	a8 fc                	test   $0xfc,%al
80102438:	75 7b                	jne    801024b5 <lapicinit+0xfb>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
8010243a:	ba 33 00 00 00       	mov    $0x33,%edx
8010243f:	b8 dc 00 00 00       	mov    $0xdc,%eax
80102444:	e8 f1 fe ff ff       	call   8010233a <lapicw>
  lapicw(ESR, 0);
80102449:	ba 00 00 00 00       	mov    $0x0,%edx
8010244e:	b8 a0 00 00 00       	mov    $0xa0,%eax
80102453:	e8 e2 fe ff ff       	call   8010233a <lapicw>
  lapicw(ESR, 0);
80102458:	ba 00 00 00 00       	mov    $0x0,%edx
8010245d:	b8 a0 00 00 00       	mov    $0xa0,%eax
80102462:	e8 d3 fe ff ff       	call   8010233a <lapicw>
  lapicw(EOI, 0);
80102467:	ba 00 00 00 00       	mov    $0x0,%edx
8010246c:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102471:	e8 c4 fe ff ff       	call   8010233a <lapicw>
  lapicw(ICRHI, 0);
80102476:	ba 00 00 00 00       	mov    $0x0,%edx
8010247b:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102480:	e8 b5 fe ff ff       	call   8010233a <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102485:	ba 00 85 08 00       	mov    $0x88500,%edx
8010248a:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010248f:	e8 a6 fe ff ff       	call   8010233a <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102494:	a1 5c 5e 11 80       	mov    0x80115e5c,%eax
80102499:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
8010249f:	f6 c4 10             	test   $0x10,%ah
801024a2:	75 f0                	jne    80102494 <lapicinit+0xda>
  lapicw(TPR, 0);
801024a4:	ba 00 00 00 00       	mov    $0x0,%edx
801024a9:	b8 20 00 00 00       	mov    $0x20,%eax
801024ae:	e8 87 fe ff ff       	call   8010233a <lapicw>
}
801024b3:	c9                   	leave  
801024b4:	c3                   	ret    
    lapicw(PCINT, MASKED);
801024b5:	ba 00 00 01 00       	mov    $0x10000,%edx
801024ba:	b8 d0 00 00 00       	mov    $0xd0,%eax
801024bf:	e8 76 fe ff ff       	call   8010233a <lapicw>
801024c4:	e9 71 ff ff ff       	jmp    8010243a <lapicinit+0x80>
801024c9:	c3                   	ret    

801024ca <lapicid>:
{
801024ca:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801024ce:	a1 5c 5e 11 80       	mov    0x80115e5c,%eax
801024d3:	85 c0                	test   %eax,%eax
801024d5:	74 07                	je     801024de <lapicid+0x14>
  return lapic[ID] >> 24;
801024d7:	8b 40 20             	mov    0x20(%eax),%eax
801024da:	c1 e8 18             	shr    $0x18,%eax
801024dd:	c3                   	ret    
    return 0;
801024de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024e3:	c3                   	ret    

801024e4 <lapiceoi>:
{
801024e4:	f3 0f 1e fb          	endbr32 
  if(lapic)
801024e8:	83 3d 5c 5e 11 80 00 	cmpl   $0x0,0x80115e5c
801024ef:	74 17                	je     80102508 <lapiceoi+0x24>
{
801024f1:	55                   	push   %ebp
801024f2:	89 e5                	mov    %esp,%ebp
801024f4:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
801024f7:	ba 00 00 00 00       	mov    $0x0,%edx
801024fc:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102501:	e8 34 fe ff ff       	call   8010233a <lapicw>
}
80102506:	c9                   	leave  
80102507:	c3                   	ret    
80102508:	c3                   	ret    

80102509 <microdelay>:
{
80102509:	f3 0f 1e fb          	endbr32 
}
8010250d:	c3                   	ret    

8010250e <lapicstartap>:
{
8010250e:	f3 0f 1e fb          	endbr32 
80102512:	55                   	push   %ebp
80102513:	89 e5                	mov    %esp,%ebp
80102515:	57                   	push   %edi
80102516:	56                   	push   %esi
80102517:	53                   	push   %ebx
80102518:	83 ec 0c             	sub    $0xc,%esp
8010251b:	8b 75 08             	mov    0x8(%ebp),%esi
8010251e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102521:	b8 0f 00 00 00       	mov    $0xf,%eax
80102526:	ba 70 00 00 00       	mov    $0x70,%edx
8010252b:	ee                   	out    %al,(%dx)
8010252c:	b8 0a 00 00 00       	mov    $0xa,%eax
80102531:	ba 71 00 00 00       	mov    $0x71,%edx
80102536:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102537:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
8010253e:	00 00 
  wrv[1] = addr >> 4;
80102540:	89 f8                	mov    %edi,%eax
80102542:	c1 e8 04             	shr    $0x4,%eax
80102545:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
8010254b:	c1 e6 18             	shl    $0x18,%esi
8010254e:	89 f2                	mov    %esi,%edx
80102550:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102555:	e8 e0 fd ff ff       	call   8010233a <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010255a:	ba 00 c5 00 00       	mov    $0xc500,%edx
8010255f:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102564:	e8 d1 fd ff ff       	call   8010233a <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
80102569:	ba 00 85 00 00       	mov    $0x8500,%edx
8010256e:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102573:	e8 c2 fd ff ff       	call   8010233a <lapicw>
  for(i = 0; i < 2; i++){
80102578:	bb 00 00 00 00       	mov    $0x0,%ebx
8010257d:	eb 21                	jmp    801025a0 <lapicstartap+0x92>
    lapicw(ICRHI, apicid<<24);
8010257f:	89 f2                	mov    %esi,%edx
80102581:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102586:	e8 af fd ff ff       	call   8010233a <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010258b:	89 fa                	mov    %edi,%edx
8010258d:	c1 ea 0c             	shr    $0xc,%edx
80102590:	80 ce 06             	or     $0x6,%dh
80102593:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102598:	e8 9d fd ff ff       	call   8010233a <lapicw>
  for(i = 0; i < 2; i++){
8010259d:	83 c3 01             	add    $0x1,%ebx
801025a0:	83 fb 01             	cmp    $0x1,%ebx
801025a3:	7e da                	jle    8010257f <lapicstartap+0x71>
}
801025a5:	83 c4 0c             	add    $0xc,%esp
801025a8:	5b                   	pop    %ebx
801025a9:	5e                   	pop    %esi
801025aa:	5f                   	pop    %edi
801025ab:	5d                   	pop    %ebp
801025ac:	c3                   	ret    

801025ad <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801025ad:	f3 0f 1e fb          	endbr32 
801025b1:	55                   	push   %ebp
801025b2:	89 e5                	mov    %esp,%ebp
801025b4:	57                   	push   %edi
801025b5:	56                   	push   %esi
801025b6:	53                   	push   %ebx
801025b7:	83 ec 3c             	sub    $0x3c,%esp
801025ba:	8b 75 08             	mov    0x8(%ebp),%esi
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801025bd:	b8 0b 00 00 00       	mov    $0xb,%eax
801025c2:	e8 87 fd ff ff       	call   8010234e <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
801025c7:	83 e0 04             	and    $0x4,%eax
801025ca:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801025cc:	8d 45 d0             	lea    -0x30(%ebp),%eax
801025cf:	e8 8a fd ff ff       	call   8010235e <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801025d4:	b8 0a 00 00 00       	mov    $0xa,%eax
801025d9:	e8 70 fd ff ff       	call   8010234e <cmos_read>
801025de:	a8 80                	test   $0x80,%al
801025e0:	75 ea                	jne    801025cc <cmostime+0x1f>
        continue;
    fill_rtcdate(&t2);
801025e2:	8d 5d b8             	lea    -0x48(%ebp),%ebx
801025e5:	89 d8                	mov    %ebx,%eax
801025e7:	e8 72 fd ff ff       	call   8010235e <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801025ec:	83 ec 04             	sub    $0x4,%esp
801025ef:	6a 18                	push   $0x18
801025f1:	53                   	push   %ebx
801025f2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801025f5:	50                   	push   %eax
801025f6:	e8 9b 2b 00 00       	call   80105196 <memcmp>
801025fb:	83 c4 10             	add    $0x10,%esp
801025fe:	85 c0                	test   %eax,%eax
80102600:	75 ca                	jne    801025cc <cmostime+0x1f>
      break;
  }

  // convert
  if(bcd) {
80102602:	85 ff                	test   %edi,%edi
80102604:	75 78                	jne    8010267e <cmostime+0xd1>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102606:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102609:	89 c2                	mov    %eax,%edx
8010260b:	c1 ea 04             	shr    $0x4,%edx
8010260e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102611:	83 e0 0f             	and    $0xf,%eax
80102614:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102617:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
8010261a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010261d:	89 c2                	mov    %eax,%edx
8010261f:	c1 ea 04             	shr    $0x4,%edx
80102622:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102625:	83 e0 0f             	and    $0xf,%eax
80102628:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010262b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
8010262e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102631:	89 c2                	mov    %eax,%edx
80102633:	c1 ea 04             	shr    $0x4,%edx
80102636:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102639:	83 e0 0f             	and    $0xf,%eax
8010263c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010263f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102642:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102645:	89 c2                	mov    %eax,%edx
80102647:	c1 ea 04             	shr    $0x4,%edx
8010264a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010264d:	83 e0 0f             	and    $0xf,%eax
80102650:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102653:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
80102656:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102659:	89 c2                	mov    %eax,%edx
8010265b:	c1 ea 04             	shr    $0x4,%edx
8010265e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102661:	83 e0 0f             	and    $0xf,%eax
80102664:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102667:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
8010266a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010266d:	89 c2                	mov    %eax,%edx
8010266f:	c1 ea 04             	shr    $0x4,%edx
80102672:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102675:	83 e0 0f             	and    $0xf,%eax
80102678:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010267b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
8010267e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102681:	89 06                	mov    %eax,(%esi)
80102683:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102686:	89 46 04             	mov    %eax,0x4(%esi)
80102689:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010268c:	89 46 08             	mov    %eax,0x8(%esi)
8010268f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102692:	89 46 0c             	mov    %eax,0xc(%esi)
80102695:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102698:	89 46 10             	mov    %eax,0x10(%esi)
8010269b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010269e:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801026a1:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801026a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026ab:	5b                   	pop    %ebx
801026ac:	5e                   	pop    %esi
801026ad:	5f                   	pop    %edi
801026ae:	5d                   	pop    %ebp
801026af:	c3                   	ret    

801026b0 <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	53                   	push   %ebx
801026b4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801026b7:	ff 35 94 5e 11 80    	pushl  0x80115e94
801026bd:	ff 35 a4 5e 11 80    	pushl  0x80115ea4
801026c3:	e8 a8 da ff ff       	call   80100170 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
801026c8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801026cb:	89 1d a8 5e 11 80    	mov    %ebx,0x80115ea8
  for (i = 0; i < log.lh.n; i++) {
801026d1:	83 c4 10             	add    $0x10,%esp
801026d4:	ba 00 00 00 00       	mov    $0x0,%edx
801026d9:	39 d3                	cmp    %edx,%ebx
801026db:	7e 10                	jle    801026ed <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
801026dd:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801026e1:	89 0c 95 ac 5e 11 80 	mov    %ecx,-0x7feea154(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801026e8:	83 c2 01             	add    $0x1,%edx
801026eb:	eb ec                	jmp    801026d9 <read_head+0x29>
  }
  brelse(buf);
801026ed:	83 ec 0c             	sub    $0xc,%esp
801026f0:	50                   	push   %eax
801026f1:	e8 eb da ff ff       	call   801001e1 <brelse>
}
801026f6:	83 c4 10             	add    $0x10,%esp
801026f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026fc:	c9                   	leave  
801026fd:	c3                   	ret    

801026fe <install_trans>:
{
801026fe:	55                   	push   %ebp
801026ff:	89 e5                	mov    %esp,%ebp
80102701:	57                   	push   %edi
80102702:	56                   	push   %esi
80102703:	53                   	push   %ebx
80102704:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102707:	be 00 00 00 00       	mov    $0x0,%esi
8010270c:	39 35 a8 5e 11 80    	cmp    %esi,0x80115ea8
80102712:	7e 68                	jle    8010277c <install_trans+0x7e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102714:	89 f0                	mov    %esi,%eax
80102716:	03 05 94 5e 11 80    	add    0x80115e94,%eax
8010271c:	83 c0 01             	add    $0x1,%eax
8010271f:	83 ec 08             	sub    $0x8,%esp
80102722:	50                   	push   %eax
80102723:	ff 35 a4 5e 11 80    	pushl  0x80115ea4
80102729:	e8 42 da ff ff       	call   80100170 <bread>
8010272e:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102730:	83 c4 08             	add    $0x8,%esp
80102733:	ff 34 b5 ac 5e 11 80 	pushl  -0x7feea154(,%esi,4)
8010273a:	ff 35 a4 5e 11 80    	pushl  0x80115ea4
80102740:	e8 2b da ff ff       	call   80100170 <bread>
80102745:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102747:	8d 57 5c             	lea    0x5c(%edi),%edx
8010274a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010274d:	83 c4 0c             	add    $0xc,%esp
80102750:	68 00 02 00 00       	push   $0x200
80102755:	52                   	push   %edx
80102756:	50                   	push   %eax
80102757:	e8 73 2a 00 00       	call   801051cf <memmove>
    bwrite(dbuf);  // write dst to disk
8010275c:	89 1c 24             	mov    %ebx,(%esp)
8010275f:	e8 3e da ff ff       	call   801001a2 <bwrite>
    brelse(lbuf);
80102764:	89 3c 24             	mov    %edi,(%esp)
80102767:	e8 75 da ff ff       	call   801001e1 <brelse>
    brelse(dbuf);
8010276c:	89 1c 24             	mov    %ebx,(%esp)
8010276f:	e8 6d da ff ff       	call   801001e1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102774:	83 c6 01             	add    $0x1,%esi
80102777:	83 c4 10             	add    $0x10,%esp
8010277a:	eb 90                	jmp    8010270c <install_trans+0xe>
}
8010277c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010277f:	5b                   	pop    %ebx
80102780:	5e                   	pop    %esi
80102781:	5f                   	pop    %edi
80102782:	5d                   	pop    %ebp
80102783:	c3                   	ret    

80102784 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	53                   	push   %ebx
80102788:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010278b:	ff 35 94 5e 11 80    	pushl  0x80115e94
80102791:	ff 35 a4 5e 11 80    	pushl  0x80115ea4
80102797:	e8 d4 d9 ff ff       	call   80100170 <bread>
8010279c:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
8010279e:	8b 0d a8 5e 11 80    	mov    0x80115ea8,%ecx
801027a4:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801027a7:	83 c4 10             	add    $0x10,%esp
801027aa:	b8 00 00 00 00       	mov    $0x0,%eax
801027af:	39 c1                	cmp    %eax,%ecx
801027b1:	7e 10                	jle    801027c3 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
801027b3:	8b 14 85 ac 5e 11 80 	mov    -0x7feea154(,%eax,4),%edx
801027ba:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
801027be:	83 c0 01             	add    $0x1,%eax
801027c1:	eb ec                	jmp    801027af <write_head+0x2b>
  }
  bwrite(buf);
801027c3:	83 ec 0c             	sub    $0xc,%esp
801027c6:	53                   	push   %ebx
801027c7:	e8 d6 d9 ff ff       	call   801001a2 <bwrite>
  brelse(buf);
801027cc:	89 1c 24             	mov    %ebx,(%esp)
801027cf:	e8 0d da ff ff       	call   801001e1 <brelse>
}
801027d4:	83 c4 10             	add    $0x10,%esp
801027d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027da:	c9                   	leave  
801027db:	c3                   	ret    

801027dc <recover_from_log>:

static void
recover_from_log(void)
{
801027dc:	55                   	push   %ebp
801027dd:	89 e5                	mov    %esp,%ebp
801027df:	83 ec 08             	sub    $0x8,%esp
  read_head();
801027e2:	e8 c9 fe ff ff       	call   801026b0 <read_head>
  install_trans(); // if committed, copy from log to disk
801027e7:	e8 12 ff ff ff       	call   801026fe <install_trans>
  log.lh.n = 0;
801027ec:	c7 05 a8 5e 11 80 00 	movl   $0x0,0x80115ea8
801027f3:	00 00 00 
  write_head(); // clear the log
801027f6:	e8 89 ff ff ff       	call   80102784 <write_head>
}
801027fb:	c9                   	leave  
801027fc:	c3                   	ret    

801027fd <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801027fd:	55                   	push   %ebp
801027fe:	89 e5                	mov    %esp,%ebp
80102800:	57                   	push   %edi
80102801:	56                   	push   %esi
80102802:	53                   	push   %ebx
80102803:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102806:	be 00 00 00 00       	mov    $0x0,%esi
8010280b:	39 35 a8 5e 11 80    	cmp    %esi,0x80115ea8
80102811:	7e 68                	jle    8010287b <write_log+0x7e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102813:	89 f0                	mov    %esi,%eax
80102815:	03 05 94 5e 11 80    	add    0x80115e94,%eax
8010281b:	83 c0 01             	add    $0x1,%eax
8010281e:	83 ec 08             	sub    $0x8,%esp
80102821:	50                   	push   %eax
80102822:	ff 35 a4 5e 11 80    	pushl  0x80115ea4
80102828:	e8 43 d9 ff ff       	call   80100170 <bread>
8010282d:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010282f:	83 c4 08             	add    $0x8,%esp
80102832:	ff 34 b5 ac 5e 11 80 	pushl  -0x7feea154(,%esi,4)
80102839:	ff 35 a4 5e 11 80    	pushl  0x80115ea4
8010283f:	e8 2c d9 ff ff       	call   80100170 <bread>
80102844:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102846:	8d 50 5c             	lea    0x5c(%eax),%edx
80102849:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010284c:	83 c4 0c             	add    $0xc,%esp
8010284f:	68 00 02 00 00       	push   $0x200
80102854:	52                   	push   %edx
80102855:	50                   	push   %eax
80102856:	e8 74 29 00 00       	call   801051cf <memmove>
    bwrite(to);  // write the log
8010285b:	89 1c 24             	mov    %ebx,(%esp)
8010285e:	e8 3f d9 ff ff       	call   801001a2 <bwrite>
    brelse(from);
80102863:	89 3c 24             	mov    %edi,(%esp)
80102866:	e8 76 d9 ff ff       	call   801001e1 <brelse>
    brelse(to);
8010286b:	89 1c 24             	mov    %ebx,(%esp)
8010286e:	e8 6e d9 ff ff       	call   801001e1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102873:	83 c6 01             	add    $0x1,%esi
80102876:	83 c4 10             	add    $0x10,%esp
80102879:	eb 90                	jmp    8010280b <write_log+0xe>
  }
}
8010287b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010287e:	5b                   	pop    %ebx
8010287f:	5e                   	pop    %esi
80102880:	5f                   	pop    %edi
80102881:	5d                   	pop    %ebp
80102882:	c3                   	ret    

80102883 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102883:	83 3d a8 5e 11 80 00 	cmpl   $0x0,0x80115ea8
8010288a:	7f 01                	jg     8010288d <commit+0xa>
8010288c:	c3                   	ret    
{
8010288d:	55                   	push   %ebp
8010288e:	89 e5                	mov    %esp,%ebp
80102890:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102893:	e8 65 ff ff ff       	call   801027fd <write_log>
    write_head();    // Write header to disk -- the real commit
80102898:	e8 e7 fe ff ff       	call   80102784 <write_head>
    install_trans(); // Now install writes to home locations
8010289d:	e8 5c fe ff ff       	call   801026fe <install_trans>
    log.lh.n = 0;
801028a2:	c7 05 a8 5e 11 80 00 	movl   $0x0,0x80115ea8
801028a9:	00 00 00 
    write_head();    // Erase the transaction from the log
801028ac:	e8 d3 fe ff ff       	call   80102784 <write_head>
  }
}
801028b1:	c9                   	leave  
801028b2:	c3                   	ret    

801028b3 <initlog>:
{
801028b3:	f3 0f 1e fb          	endbr32 
801028b7:	55                   	push   %ebp
801028b8:	89 e5                	mov    %esp,%ebp
801028ba:	53                   	push   %ebx
801028bb:	83 ec 2c             	sub    $0x2c,%esp
801028be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801028c1:	68 a0 80 10 80       	push   $0x801080a0
801028c6:	68 60 5e 11 80       	push   $0x80115e60
801028cb:	e8 7b 26 00 00       	call   80104f4b <initlock>
  readsb(dev, &sb);
801028d0:	83 c4 08             	add    $0x8,%esp
801028d3:	8d 45 dc             	lea    -0x24(%ebp),%eax
801028d6:	50                   	push   %eax
801028d7:	53                   	push   %ebx
801028d8:	e8 3b ea ff ff       	call   80101318 <readsb>
  log.start = sb.logstart;
801028dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801028e0:	a3 94 5e 11 80       	mov    %eax,0x80115e94
  log.size = sb.nlog;
801028e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801028e8:	a3 98 5e 11 80       	mov    %eax,0x80115e98
  log.dev = dev;
801028ed:	89 1d a4 5e 11 80    	mov    %ebx,0x80115ea4
  recover_from_log();
801028f3:	e8 e4 fe ff ff       	call   801027dc <recover_from_log>
}
801028f8:	83 c4 10             	add    $0x10,%esp
801028fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028fe:	c9                   	leave  
801028ff:	c3                   	ret    

80102900 <begin_op>:
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
80102905:	89 e5                	mov    %esp,%ebp
80102907:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010290a:	68 60 5e 11 80       	push   $0x80115e60
8010290f:	e8 87 27 00 00       	call   8010509b <acquire>
80102914:	83 c4 10             	add    $0x10,%esp
80102917:	eb 15                	jmp    8010292e <begin_op+0x2e>
      sleep(&log, &log.lock);
80102919:	83 ec 08             	sub    $0x8,%esp
8010291c:	68 60 5e 11 80       	push   $0x80115e60
80102921:	68 60 5e 11 80       	push   $0x80115e60
80102926:	e8 b6 17 00 00       	call   801040e1 <sleep>
8010292b:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010292e:	83 3d a0 5e 11 80 00 	cmpl   $0x0,0x80115ea0
80102935:	75 e2                	jne    80102919 <begin_op+0x19>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102937:	a1 9c 5e 11 80       	mov    0x80115e9c,%eax
8010293c:	83 c0 01             	add    $0x1,%eax
8010293f:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102942:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
80102945:	03 15 a8 5e 11 80    	add    0x80115ea8,%edx
8010294b:	83 fa 1e             	cmp    $0x1e,%edx
8010294e:	7e 17                	jle    80102967 <begin_op+0x67>
      sleep(&log, &log.lock);
80102950:	83 ec 08             	sub    $0x8,%esp
80102953:	68 60 5e 11 80       	push   $0x80115e60
80102958:	68 60 5e 11 80       	push   $0x80115e60
8010295d:	e8 7f 17 00 00       	call   801040e1 <sleep>
80102962:	83 c4 10             	add    $0x10,%esp
80102965:	eb c7                	jmp    8010292e <begin_op+0x2e>
      log.outstanding += 1;
80102967:	a3 9c 5e 11 80       	mov    %eax,0x80115e9c
      release(&log.lock);
8010296c:	83 ec 0c             	sub    $0xc,%esp
8010296f:	68 60 5e 11 80       	push   $0x80115e60
80102974:	e8 8b 27 00 00       	call   80105104 <release>
}
80102979:	83 c4 10             	add    $0x10,%esp
8010297c:	c9                   	leave  
8010297d:	c3                   	ret    

8010297e <end_op>:
{
8010297e:	f3 0f 1e fb          	endbr32 
80102982:	55                   	push   %ebp
80102983:	89 e5                	mov    %esp,%ebp
80102985:	53                   	push   %ebx
80102986:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
80102989:	68 60 5e 11 80       	push   $0x80115e60
8010298e:	e8 08 27 00 00       	call   8010509b <acquire>
  log.outstanding -= 1;
80102993:	a1 9c 5e 11 80       	mov    0x80115e9c,%eax
80102998:	83 e8 01             	sub    $0x1,%eax
8010299b:	a3 9c 5e 11 80       	mov    %eax,0x80115e9c
  if(log.committing)
801029a0:	8b 1d a0 5e 11 80    	mov    0x80115ea0,%ebx
801029a6:	83 c4 10             	add    $0x10,%esp
801029a9:	85 db                	test   %ebx,%ebx
801029ab:	75 2c                	jne    801029d9 <end_op+0x5b>
  if(log.outstanding == 0){
801029ad:	85 c0                	test   %eax,%eax
801029af:	75 35                	jne    801029e6 <end_op+0x68>
    log.committing = 1;
801029b1:	c7 05 a0 5e 11 80 01 	movl   $0x1,0x80115ea0
801029b8:	00 00 00 
    do_commit = 1;
801029bb:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
801029c0:	83 ec 0c             	sub    $0xc,%esp
801029c3:	68 60 5e 11 80       	push   $0x80115e60
801029c8:	e8 37 27 00 00       	call   80105104 <release>
  if(do_commit){
801029cd:	83 c4 10             	add    $0x10,%esp
801029d0:	85 db                	test   %ebx,%ebx
801029d2:	75 24                	jne    801029f8 <end_op+0x7a>
}
801029d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029d7:	c9                   	leave  
801029d8:	c3                   	ret    
    panic("log.committing");
801029d9:	83 ec 0c             	sub    $0xc,%esp
801029dc:	68 a4 80 10 80       	push   $0x801080a4
801029e1:	e8 76 d9 ff ff       	call   8010035c <panic>
    wakeup(&log);
801029e6:	83 ec 0c             	sub    $0xc,%esp
801029e9:	68 60 5e 11 80       	push   $0x80115e60
801029ee:	e8 ed 19 00 00       	call   801043e0 <wakeup>
801029f3:	83 c4 10             	add    $0x10,%esp
801029f6:	eb c8                	jmp    801029c0 <end_op+0x42>
    commit();
801029f8:	e8 86 fe ff ff       	call   80102883 <commit>
    acquire(&log.lock);
801029fd:	83 ec 0c             	sub    $0xc,%esp
80102a00:	68 60 5e 11 80       	push   $0x80115e60
80102a05:	e8 91 26 00 00       	call   8010509b <acquire>
    log.committing = 0;
80102a0a:	c7 05 a0 5e 11 80 00 	movl   $0x0,0x80115ea0
80102a11:	00 00 00 
    wakeup(&log);
80102a14:	c7 04 24 60 5e 11 80 	movl   $0x80115e60,(%esp)
80102a1b:	e8 c0 19 00 00       	call   801043e0 <wakeup>
    release(&log.lock);
80102a20:	c7 04 24 60 5e 11 80 	movl   $0x80115e60,(%esp)
80102a27:	e8 d8 26 00 00       	call   80105104 <release>
80102a2c:	83 c4 10             	add    $0x10,%esp
}
80102a2f:	eb a3                	jmp    801029d4 <end_op+0x56>

80102a31 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102a31:	f3 0f 1e fb          	endbr32 
80102a35:	55                   	push   %ebp
80102a36:	89 e5                	mov    %esp,%ebp
80102a38:	53                   	push   %ebx
80102a39:	83 ec 04             	sub    $0x4,%esp
80102a3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102a3f:	8b 15 a8 5e 11 80    	mov    0x80115ea8,%edx
80102a45:	83 fa 1d             	cmp    $0x1d,%edx
80102a48:	7f 45                	jg     80102a8f <log_write+0x5e>
80102a4a:	a1 98 5e 11 80       	mov    0x80115e98,%eax
80102a4f:	83 e8 01             	sub    $0x1,%eax
80102a52:	39 c2                	cmp    %eax,%edx
80102a54:	7d 39                	jge    80102a8f <log_write+0x5e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102a56:	83 3d 9c 5e 11 80 00 	cmpl   $0x0,0x80115e9c
80102a5d:	7e 3d                	jle    80102a9c <log_write+0x6b>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102a5f:	83 ec 0c             	sub    $0xc,%esp
80102a62:	68 60 5e 11 80       	push   $0x80115e60
80102a67:	e8 2f 26 00 00       	call   8010509b <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102a6c:	83 c4 10             	add    $0x10,%esp
80102a6f:	b8 00 00 00 00       	mov    $0x0,%eax
80102a74:	8b 15 a8 5e 11 80    	mov    0x80115ea8,%edx
80102a7a:	39 c2                	cmp    %eax,%edx
80102a7c:	7e 2b                	jle    80102aa9 <log_write+0x78>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102a7e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102a81:	39 0c 85 ac 5e 11 80 	cmp    %ecx,-0x7feea154(,%eax,4)
80102a88:	74 1f                	je     80102aa9 <log_write+0x78>
  for (i = 0; i < log.lh.n; i++) {
80102a8a:	83 c0 01             	add    $0x1,%eax
80102a8d:	eb e5                	jmp    80102a74 <log_write+0x43>
    panic("too big a transaction");
80102a8f:	83 ec 0c             	sub    $0xc,%esp
80102a92:	68 b3 80 10 80       	push   $0x801080b3
80102a97:	e8 c0 d8 ff ff       	call   8010035c <panic>
    panic("log_write outside of trans");
80102a9c:	83 ec 0c             	sub    $0xc,%esp
80102a9f:	68 c9 80 10 80       	push   $0x801080c9
80102aa4:	e8 b3 d8 ff ff       	call   8010035c <panic>
      break;
  }
  log.lh.block[i] = b->blockno;
80102aa9:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102aac:	89 0c 85 ac 5e 11 80 	mov    %ecx,-0x7feea154(,%eax,4)
  if (i == log.lh.n)
80102ab3:	39 c2                	cmp    %eax,%edx
80102ab5:	74 18                	je     80102acf <log_write+0x9e>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102ab7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102aba:	83 ec 0c             	sub    $0xc,%esp
80102abd:	68 60 5e 11 80       	push   $0x80115e60
80102ac2:	e8 3d 26 00 00       	call   80105104 <release>
}
80102ac7:	83 c4 10             	add    $0x10,%esp
80102aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102acd:	c9                   	leave  
80102ace:	c3                   	ret    
    log.lh.n++;
80102acf:	83 c2 01             	add    $0x1,%edx
80102ad2:	89 15 a8 5e 11 80    	mov    %edx,0x80115ea8
80102ad8:	eb dd                	jmp    80102ab7 <log_write+0x86>

80102ada <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80102ada:	55                   	push   %ebp
80102adb:	89 e5                	mov    %esp,%ebp
80102add:	53                   	push   %ebx
80102ade:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ae1:	68 8a 00 00 00       	push   $0x8a
80102ae6:	68 8c b4 10 80       	push   $0x8010b48c
80102aeb:	68 00 70 00 80       	push   $0x80007000
80102af0:	e8 da 26 00 00       	call   801051cf <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102af5:	83 c4 10             	add    $0x10,%esp
80102af8:	bb 60 5f 11 80       	mov    $0x80115f60,%ebx
80102afd:	eb 47                	jmp    80102b46 <startothers+0x6c>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102aff:	e8 ff f6 ff ff       	call   80102203 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102b04:	05 00 10 00 00       	add    $0x1000,%eax
80102b09:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
80102b0e:	c7 05 f8 6f 00 80 a8 	movl   $0x80102ba8,0x80006ff8
80102b15:	2b 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102b18:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102b1f:	a0 10 00 

    lapicstartap(c->apicid, V2P(code));
80102b22:	83 ec 08             	sub    $0x8,%esp
80102b25:	68 00 70 00 00       	push   $0x7000
80102b2a:	0f b6 03             	movzbl (%ebx),%eax
80102b2d:	50                   	push   %eax
80102b2e:	e8 db f9 ff ff       	call   8010250e <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102b33:	83 c4 10             	add    $0x10,%esp
80102b36:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102b3c:	85 c0                	test   %eax,%eax
80102b3e:	74 f6                	je     80102b36 <startothers+0x5c>
  for(c = cpus; c < cpus+ncpu; c++){
80102b40:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102b46:	69 05 e0 64 11 80 b0 	imul   $0xb0,0x801164e0,%eax
80102b4d:	00 00 00 
80102b50:	05 60 5f 11 80       	add    $0x80115f60,%eax
80102b55:	39 d8                	cmp    %ebx,%eax
80102b57:	76 0b                	jbe    80102b64 <startothers+0x8a>
    if(c == mycpu())  // We've started already.
80102b59:	e8 ab 0c 00 00       	call   80103809 <mycpu>
80102b5e:	39 c3                	cmp    %eax,%ebx
80102b60:	74 de                	je     80102b40 <startothers+0x66>
80102b62:	eb 9b                	jmp    80102aff <startothers+0x25>
      ;
  }
}
80102b64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b67:	c9                   	leave  
80102b68:	c3                   	ret    

80102b69 <mpmain>:
{
80102b69:	55                   	push   %ebp
80102b6a:	89 e5                	mov    %esp,%ebp
80102b6c:	53                   	push   %ebx
80102b6d:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102b70:	e8 f4 0c 00 00       	call   80103869 <cpuid>
80102b75:	89 c3                	mov    %eax,%ebx
80102b77:	e8 ed 0c 00 00       	call   80103869 <cpuid>
80102b7c:	83 ec 04             	sub    $0x4,%esp
80102b7f:	53                   	push   %ebx
80102b80:	50                   	push   %eax
80102b81:	68 e4 80 10 80       	push   $0x801080e4
80102b86:	e8 9e da ff ff       	call   80100629 <cprintf>
  idtinit();       // load idt register
80102b8b:	e8 3b 39 00 00       	call   801064cb <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102b90:	e8 74 0c 00 00       	call   80103809 <mycpu>
80102b95:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102b97:	b8 01 00 00 00       	mov    $0x1,%eax
80102b9c:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102ba3:	e8 c4 10 00 00       	call   80103c6c <scheduler>

80102ba8 <mpenter>:
{
80102ba8:	f3 0f 1e fb          	endbr32 
80102bac:	55                   	push   %ebp
80102bad:	89 e5                	mov    %esp,%ebp
80102baf:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102bb2:	e8 3b 49 00 00       	call   801074f2 <switchkvm>
  seginit();
80102bb7:	e8 e6 47 00 00       	call   801073a2 <seginit>
  lapicinit();
80102bbc:	e8 f9 f7 ff ff       	call   801023ba <lapicinit>
  mpmain();
80102bc1:	e8 a3 ff ff ff       	call   80102b69 <mpmain>

80102bc6 <main>:
{
80102bc6:	f3 0f 1e fb          	endbr32 
80102bca:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102bce:	83 e4 f0             	and    $0xfffffff0,%esp
80102bd1:	ff 71 fc             	pushl  -0x4(%ecx)
80102bd4:	55                   	push   %ebp
80102bd5:	89 e5                	mov    %esp,%ebp
80102bd7:	51                   	push   %ecx
80102bd8:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102bdb:	68 00 00 40 80       	push   $0x80400000
80102be0:	68 08 6d 11 80       	push   $0x80116d08
80102be5:	e8 bf f5 ff ff       	call   801021a9 <kinit1>
  kvmalloc();      // kernel page table
80102bea:	e8 a6 4d 00 00       	call   80107995 <kvmalloc>
  mpinit();        // detect other processors
80102bef:	e8 c1 01 00 00       	call   80102db5 <mpinit>
  lapicinit();     // interrupt controller
80102bf4:	e8 c1 f7 ff ff       	call   801023ba <lapicinit>
  seginit();       // segment descriptors
80102bf9:	e8 a4 47 00 00       	call   801073a2 <seginit>
  picinit();       // disable pic
80102bfe:	e8 8c 02 00 00       	call   80102e8f <picinit>
  ioapicinit();    // another interrupt controller
80102c03:	e8 1c f4 ff ff       	call   80102024 <ioapicinit>
  consoleinit();   // console hardware
80102c08:	e8 5a dd ff ff       	call   80100967 <consoleinit>
  uartinit();      // serial port
80102c0d:	e8 78 3b 00 00       	call   8010678a <uartinit>
  pinit();         // process table
80102c12:	e8 d4 0b 00 00       	call   801037eb <pinit>
  tvinit();        // trap vectors
80102c17:	e8 16 38 00 00       	call   80106432 <tvinit>
  binit();         // buffer cache
80102c1c:	e8 d3 d4 ff ff       	call   801000f4 <binit>
  fileinit();      // file table
80102c21:	e8 b6 e0 ff ff       	call   80100cdc <fileinit>
  ideinit();       // disk 
80102c26:	e8 fb f1 ff ff       	call   80101e26 <ideinit>
  startothers();   // start other processors
80102c2b:	e8 aa fe ff ff       	call   80102ada <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102c30:	83 c4 08             	add    $0x8,%esp
80102c33:	68 00 00 00 8e       	push   $0x8e000000
80102c38:	68 00 00 40 80       	push   $0x80400000
80102c3d:	e8 9d f5 ff ff       	call   801021df <kinit2>
  userinit();      // first user process
80102c42:	e8 69 0c 00 00       	call   801038b0 <userinit>
  mpmain();        // finish this processor's setup
80102c47:	e8 1d ff ff ff       	call   80102b69 <mpmain>

80102c4c <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102c4c:	55                   	push   %ebp
80102c4d:	89 e5                	mov    %esp,%ebp
80102c4f:	56                   	push   %esi
80102c50:	53                   	push   %ebx
80102c51:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102c53:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102c58:	b9 00 00 00 00       	mov    $0x0,%ecx
80102c5d:	39 d1                	cmp    %edx,%ecx
80102c5f:	7d 0b                	jge    80102c6c <sum+0x20>
    sum += addr[i];
80102c61:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102c65:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102c67:	83 c1 01             	add    $0x1,%ecx
80102c6a:	eb f1                	jmp    80102c5d <sum+0x11>
  return sum;
}
80102c6c:	5b                   	pop    %ebx
80102c6d:	5e                   	pop    %esi
80102c6e:	5d                   	pop    %ebp
80102c6f:	c3                   	ret    

80102c70 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	56                   	push   %esi
80102c74:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102c75:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102c7b:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102c7d:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102c7f:	eb 03                	jmp    80102c84 <mpsearch1+0x14>
80102c81:	83 c3 10             	add    $0x10,%ebx
80102c84:	39 f3                	cmp    %esi,%ebx
80102c86:	73 29                	jae    80102cb1 <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102c88:	83 ec 04             	sub    $0x4,%esp
80102c8b:	6a 04                	push   $0x4
80102c8d:	68 f8 80 10 80       	push   $0x801080f8
80102c92:	53                   	push   %ebx
80102c93:	e8 fe 24 00 00       	call   80105196 <memcmp>
80102c98:	83 c4 10             	add    $0x10,%esp
80102c9b:	85 c0                	test   %eax,%eax
80102c9d:	75 e2                	jne    80102c81 <mpsearch1+0x11>
80102c9f:	ba 10 00 00 00       	mov    $0x10,%edx
80102ca4:	89 d8                	mov    %ebx,%eax
80102ca6:	e8 a1 ff ff ff       	call   80102c4c <sum>
80102cab:	84 c0                	test   %al,%al
80102cad:	75 d2                	jne    80102c81 <mpsearch1+0x11>
80102caf:	eb 05                	jmp    80102cb6 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102cb1:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102cb6:	89 d8                	mov    %ebx,%eax
80102cb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102cbb:	5b                   	pop    %ebx
80102cbc:	5e                   	pop    %esi
80102cbd:	5d                   	pop    %ebp
80102cbe:	c3                   	ret    

80102cbf <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102cbf:	55                   	push   %ebp
80102cc0:	89 e5                	mov    %esp,%ebp
80102cc2:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102cc5:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102ccc:	c1 e0 08             	shl    $0x8,%eax
80102ccf:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102cd6:	09 d0                	or     %edx,%eax
80102cd8:	c1 e0 04             	shl    $0x4,%eax
80102cdb:	74 1f                	je     80102cfc <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102cdd:	ba 00 04 00 00       	mov    $0x400,%edx
80102ce2:	e8 89 ff ff ff       	call   80102c70 <mpsearch1>
80102ce7:	85 c0                	test   %eax,%eax
80102ce9:	75 0f                	jne    80102cfa <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102ceb:	ba 00 00 01 00       	mov    $0x10000,%edx
80102cf0:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102cf5:	e8 76 ff ff ff       	call   80102c70 <mpsearch1>
}
80102cfa:	c9                   	leave  
80102cfb:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102cfc:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102d03:	c1 e0 08             	shl    $0x8,%eax
80102d06:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102d0d:	09 d0                	or     %edx,%eax
80102d0f:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102d12:	2d 00 04 00 00       	sub    $0x400,%eax
80102d17:	ba 00 04 00 00       	mov    $0x400,%edx
80102d1c:	e8 4f ff ff ff       	call   80102c70 <mpsearch1>
80102d21:	85 c0                	test   %eax,%eax
80102d23:	75 d5                	jne    80102cfa <mpsearch+0x3b>
80102d25:	eb c4                	jmp    80102ceb <mpsearch+0x2c>

80102d27 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102d27:	55                   	push   %ebp
80102d28:	89 e5                	mov    %esp,%ebp
80102d2a:	57                   	push   %edi
80102d2b:	56                   	push   %esi
80102d2c:	53                   	push   %ebx
80102d2d:	83 ec 1c             	sub    $0x1c,%esp
80102d30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102d33:	e8 87 ff ff ff       	call   80102cbf <mpsearch>
80102d38:	89 c3                	mov    %eax,%ebx
80102d3a:	85 c0                	test   %eax,%eax
80102d3c:	74 5a                	je     80102d98 <mpconfig+0x71>
80102d3e:	8b 70 04             	mov    0x4(%eax),%esi
80102d41:	85 f6                	test   %esi,%esi
80102d43:	74 57                	je     80102d9c <mpconfig+0x75>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102d45:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102d4b:	83 ec 04             	sub    $0x4,%esp
80102d4e:	6a 04                	push   $0x4
80102d50:	68 fd 80 10 80       	push   $0x801080fd
80102d55:	57                   	push   %edi
80102d56:	e8 3b 24 00 00       	call   80105196 <memcmp>
80102d5b:	83 c4 10             	add    $0x10,%esp
80102d5e:	85 c0                	test   %eax,%eax
80102d60:	75 3e                	jne    80102da0 <mpconfig+0x79>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102d62:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102d69:	3c 01                	cmp    $0x1,%al
80102d6b:	0f 95 c2             	setne  %dl
80102d6e:	3c 04                	cmp    $0x4,%al
80102d70:	0f 95 c0             	setne  %al
80102d73:	84 c2                	test   %al,%dl
80102d75:	75 30                	jne    80102da7 <mpconfig+0x80>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102d77:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102d7e:	89 f8                	mov    %edi,%eax
80102d80:	e8 c7 fe ff ff       	call   80102c4c <sum>
80102d85:	84 c0                	test   %al,%al
80102d87:	75 25                	jne    80102dae <mpconfig+0x87>
    return 0;
  *pmp = mp;
80102d89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d8c:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102d8e:	89 f8                	mov    %edi,%eax
80102d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d93:	5b                   	pop    %ebx
80102d94:	5e                   	pop    %esi
80102d95:	5f                   	pop    %edi
80102d96:	5d                   	pop    %ebp
80102d97:	c3                   	ret    
    return 0;
80102d98:	89 c7                	mov    %eax,%edi
80102d9a:	eb f2                	jmp    80102d8e <mpconfig+0x67>
80102d9c:	89 f7                	mov    %esi,%edi
80102d9e:	eb ee                	jmp    80102d8e <mpconfig+0x67>
    return 0;
80102da0:	bf 00 00 00 00       	mov    $0x0,%edi
80102da5:	eb e7                	jmp    80102d8e <mpconfig+0x67>
    return 0;
80102da7:	bf 00 00 00 00       	mov    $0x0,%edi
80102dac:	eb e0                	jmp    80102d8e <mpconfig+0x67>
    return 0;
80102dae:	bf 00 00 00 00       	mov    $0x0,%edi
80102db3:	eb d9                	jmp    80102d8e <mpconfig+0x67>

80102db5 <mpinit>:

void
mpinit(void)
{
80102db5:	f3 0f 1e fb          	endbr32 
80102db9:	55                   	push   %ebp
80102dba:	89 e5                	mov    %esp,%ebp
80102dbc:	57                   	push   %edi
80102dbd:	56                   	push   %esi
80102dbe:	53                   	push   %ebx
80102dbf:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102dc2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102dc5:	e8 5d ff ff ff       	call   80102d27 <mpconfig>
80102dca:	85 c0                	test   %eax,%eax
80102dcc:	74 19                	je     80102de7 <mpinit+0x32>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102dce:	8b 50 24             	mov    0x24(%eax),%edx
80102dd1:	89 15 5c 5e 11 80    	mov    %edx,0x80115e5c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102dd7:	8d 50 2c             	lea    0x2c(%eax),%edx
80102dda:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102dde:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102de0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102de5:	eb 20                	jmp    80102e07 <mpinit+0x52>
    panic("Expect to run on an SMP");
80102de7:	83 ec 0c             	sub    $0xc,%esp
80102dea:	68 02 81 10 80       	push   $0x80108102
80102def:	e8 68 d5 ff ff       	call   8010035c <panic>
    switch(*p){
80102df4:	bb 00 00 00 00       	mov    $0x0,%ebx
80102df9:	eb 0c                	jmp    80102e07 <mpinit+0x52>
80102dfb:	83 e8 03             	sub    $0x3,%eax
80102dfe:	3c 01                	cmp    $0x1,%al
80102e00:	76 1a                	jbe    80102e1c <mpinit+0x67>
80102e02:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102e07:	39 ca                	cmp    %ecx,%edx
80102e09:	73 4d                	jae    80102e58 <mpinit+0xa3>
    switch(*p){
80102e0b:	0f b6 02             	movzbl (%edx),%eax
80102e0e:	3c 02                	cmp    $0x2,%al
80102e10:	74 38                	je     80102e4a <mpinit+0x95>
80102e12:	77 e7                	ja     80102dfb <mpinit+0x46>
80102e14:	84 c0                	test   %al,%al
80102e16:	74 09                	je     80102e21 <mpinit+0x6c>
80102e18:	3c 01                	cmp    $0x1,%al
80102e1a:	75 d8                	jne    80102df4 <mpinit+0x3f>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102e1c:	83 c2 08             	add    $0x8,%edx
      continue;
80102e1f:	eb e6                	jmp    80102e07 <mpinit+0x52>
      if(ncpu < NCPU) {
80102e21:	8b 35 e0 64 11 80    	mov    0x801164e0,%esi
80102e27:	83 fe 07             	cmp    $0x7,%esi
80102e2a:	7f 19                	jg     80102e45 <mpinit+0x90>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102e2c:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102e30:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80102e36:	88 87 60 5f 11 80    	mov    %al,-0x7feea0a0(%edi)
        ncpu++;
80102e3c:	83 c6 01             	add    $0x1,%esi
80102e3f:	89 35 e0 64 11 80    	mov    %esi,0x801164e0
      p += sizeof(struct mpproc);
80102e45:	83 c2 14             	add    $0x14,%edx
      continue;
80102e48:	eb bd                	jmp    80102e07 <mpinit+0x52>
      ioapicid = ioapic->apicno;
80102e4a:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102e4e:	a2 40 5f 11 80       	mov    %al,0x80115f40
      p += sizeof(struct mpioapic);
80102e53:	83 c2 08             	add    $0x8,%edx
      continue;
80102e56:	eb af                	jmp    80102e07 <mpinit+0x52>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102e58:	85 db                	test   %ebx,%ebx
80102e5a:	74 26                	je     80102e82 <mpinit+0xcd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102e5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102e5f:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102e63:	74 15                	je     80102e7a <mpinit+0xc5>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e65:	b8 70 00 00 00       	mov    $0x70,%eax
80102e6a:	ba 22 00 00 00       	mov    $0x22,%edx
80102e6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e70:	ba 23 00 00 00       	mov    $0x23,%edx
80102e75:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102e76:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e79:	ee                   	out    %al,(%dx)
  }
}
80102e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e7d:	5b                   	pop    %ebx
80102e7e:	5e                   	pop    %esi
80102e7f:	5f                   	pop    %edi
80102e80:	5d                   	pop    %ebp
80102e81:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102e82:	83 ec 0c             	sub    $0xc,%esp
80102e85:	68 1c 81 10 80       	push   $0x8010811c
80102e8a:	e8 cd d4 ff ff       	call   8010035c <panic>

80102e8f <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102e8f:	f3 0f 1e fb          	endbr32 
80102e93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e98:	ba 21 00 00 00       	mov    $0x21,%edx
80102e9d:	ee                   	out    %al,(%dx)
80102e9e:	ba a1 00 00 00       	mov    $0xa1,%edx
80102ea3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102ea4:	c3                   	ret    

80102ea5 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102ea5:	f3 0f 1e fb          	endbr32 
80102ea9:	55                   	push   %ebp
80102eaa:	89 e5                	mov    %esp,%ebp
80102eac:	57                   	push   %edi
80102ead:	56                   	push   %esi
80102eae:	53                   	push   %ebx
80102eaf:	83 ec 0c             	sub    $0xc,%esp
80102eb2:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102eb5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102eb8:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102ebe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102ec4:	e8 31 de ff ff       	call   80100cfa <filealloc>
80102ec9:	89 03                	mov    %eax,(%ebx)
80102ecb:	85 c0                	test   %eax,%eax
80102ecd:	0f 84 88 00 00 00    	je     80102f5b <pipealloc+0xb6>
80102ed3:	e8 22 de ff ff       	call   80100cfa <filealloc>
80102ed8:	89 06                	mov    %eax,(%esi)
80102eda:	85 c0                	test   %eax,%eax
80102edc:	74 7d                	je     80102f5b <pipealloc+0xb6>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102ede:	e8 20 f3 ff ff       	call   80102203 <kalloc>
80102ee3:	89 c7                	mov    %eax,%edi
80102ee5:	85 c0                	test   %eax,%eax
80102ee7:	74 72                	je     80102f5b <pipealloc+0xb6>
    goto bad;
  p->readopen = 1;
80102ee9:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102ef0:	00 00 00 
  p->writeopen = 1;
80102ef3:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102efa:	00 00 00 
  p->nwrite = 0;
80102efd:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102f04:	00 00 00 
  p->nread = 0;
80102f07:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102f0e:	00 00 00 
  initlock(&p->lock, "pipe");
80102f11:	83 ec 08             	sub    $0x8,%esp
80102f14:	68 3b 81 10 80       	push   $0x8010813b
80102f19:	50                   	push   %eax
80102f1a:	e8 2c 20 00 00       	call   80104f4b <initlock>
  (*f0)->type = FD_PIPE;
80102f1f:	8b 03                	mov    (%ebx),%eax
80102f21:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102f27:	8b 03                	mov    (%ebx),%eax
80102f29:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102f2d:	8b 03                	mov    (%ebx),%eax
80102f2f:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102f33:	8b 03                	mov    (%ebx),%eax
80102f35:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102f38:	8b 06                	mov    (%esi),%eax
80102f3a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102f40:	8b 06                	mov    (%esi),%eax
80102f42:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102f46:	8b 06                	mov    (%esi),%eax
80102f48:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102f4c:	8b 06                	mov    (%esi),%eax
80102f4e:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102f51:	83 c4 10             	add    $0x10,%esp
80102f54:	b8 00 00 00 00       	mov    $0x0,%eax
80102f59:	eb 29                	jmp    80102f84 <pipealloc+0xdf>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102f5b:	8b 03                	mov    (%ebx),%eax
80102f5d:	85 c0                	test   %eax,%eax
80102f5f:	74 0c                	je     80102f6d <pipealloc+0xc8>
    fileclose(*f0);
80102f61:	83 ec 0c             	sub    $0xc,%esp
80102f64:	50                   	push   %eax
80102f65:	e8 3e de ff ff       	call   80100da8 <fileclose>
80102f6a:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102f6d:	8b 06                	mov    (%esi),%eax
80102f6f:	85 c0                	test   %eax,%eax
80102f71:	74 19                	je     80102f8c <pipealloc+0xe7>
    fileclose(*f1);
80102f73:	83 ec 0c             	sub    $0xc,%esp
80102f76:	50                   	push   %eax
80102f77:	e8 2c de ff ff       	call   80100da8 <fileclose>
80102f7c:	83 c4 10             	add    $0x10,%esp
  return -1;
80102f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f87:	5b                   	pop    %ebx
80102f88:	5e                   	pop    %esi
80102f89:	5f                   	pop    %edi
80102f8a:	5d                   	pop    %ebp
80102f8b:	c3                   	ret    
  return -1;
80102f8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102f91:	eb f1                	jmp    80102f84 <pipealloc+0xdf>

80102f93 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102f93:	f3 0f 1e fb          	endbr32 
80102f97:	55                   	push   %ebp
80102f98:	89 e5                	mov    %esp,%ebp
80102f9a:	53                   	push   %ebx
80102f9b:	83 ec 10             	sub    $0x10,%esp
80102f9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102fa1:	53                   	push   %ebx
80102fa2:	e8 f4 20 00 00       	call   8010509b <acquire>
  if(writable){
80102fa7:	83 c4 10             	add    $0x10,%esp
80102faa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102fae:	74 3f                	je     80102fef <pipeclose+0x5c>
    p->writeopen = 0;
80102fb0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102fb7:	00 00 00 
    wakeup(&p->nread);
80102fba:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fc0:	83 ec 0c             	sub    $0xc,%esp
80102fc3:	50                   	push   %eax
80102fc4:	e8 17 14 00 00       	call   801043e0 <wakeup>
80102fc9:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102fcc:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102fd3:	75 09                	jne    80102fde <pipeclose+0x4b>
80102fd5:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102fdc:	74 2f                	je     8010300d <pipeclose+0x7a>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	53                   	push   %ebx
80102fe2:	e8 1d 21 00 00       	call   80105104 <release>
80102fe7:	83 c4 10             	add    $0x10,%esp
}
80102fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fed:	c9                   	leave  
80102fee:	c3                   	ret    
    p->readopen = 0;
80102fef:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102ff6:	00 00 00 
    wakeup(&p->nwrite);
80102ff9:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102fff:	83 ec 0c             	sub    $0xc,%esp
80103002:	50                   	push   %eax
80103003:	e8 d8 13 00 00       	call   801043e0 <wakeup>
80103008:	83 c4 10             	add    $0x10,%esp
8010300b:	eb bf                	jmp    80102fcc <pipeclose+0x39>
    release(&p->lock);
8010300d:	83 ec 0c             	sub    $0xc,%esp
80103010:	53                   	push   %ebx
80103011:	e8 ee 20 00 00       	call   80105104 <release>
    kfree((char*)p);
80103016:	89 1c 24             	mov    %ebx,(%esp)
80103019:	e8 be f0 ff ff       	call   801020dc <kfree>
8010301e:	83 c4 10             	add    $0x10,%esp
80103021:	eb c7                	jmp    80102fea <pipeclose+0x57>

80103023 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103023:	f3 0f 1e fb          	endbr32 
80103027:	55                   	push   %ebp
80103028:	89 e5                	mov    %esp,%ebp
8010302a:	57                   	push   %edi
8010302b:	56                   	push   %esi
8010302c:	53                   	push   %ebx
8010302d:	83 ec 18             	sub    $0x18,%esp
80103030:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103033:	89 de                	mov    %ebx,%esi
80103035:	53                   	push   %ebx
80103036:	e8 60 20 00 00       	call   8010509b <acquire>
  for(i = 0; i < n; i++){
8010303b:	83 c4 10             	add    $0x10,%esp
8010303e:	bf 00 00 00 00       	mov    $0x0,%edi
80103043:	3b 7d 10             	cmp    0x10(%ebp),%edi
80103046:	7c 41                	jl     80103089 <pipewrite+0x66>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103048:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010304e:	83 ec 0c             	sub    $0xc,%esp
80103051:	50                   	push   %eax
80103052:	e8 89 13 00 00       	call   801043e0 <wakeup>
  release(&p->lock);
80103057:	89 1c 24             	mov    %ebx,(%esp)
8010305a:	e8 a5 20 00 00       	call   80105104 <release>
  return n;
8010305f:	83 c4 10             	add    $0x10,%esp
80103062:	8b 45 10             	mov    0x10(%ebp),%eax
80103065:	eb 5c                	jmp    801030c3 <pipewrite+0xa0>
      wakeup(&p->nread);
80103067:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010306d:	83 ec 0c             	sub    $0xc,%esp
80103070:	50                   	push   %eax
80103071:	e8 6a 13 00 00       	call   801043e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103076:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010307c:	83 c4 08             	add    $0x8,%esp
8010307f:	56                   	push   %esi
80103080:	50                   	push   %eax
80103081:	e8 5b 10 00 00       	call   801040e1 <sleep>
80103086:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103089:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010308f:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103095:	05 00 02 00 00       	add    $0x200,%eax
8010309a:	39 c2                	cmp    %eax,%edx
8010309c:	75 2d                	jne    801030cb <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
8010309e:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
801030a5:	74 0b                	je     801030b2 <pipewrite+0x8f>
801030a7:	e8 dc 07 00 00       	call   80103888 <myproc>
801030ac:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801030b0:	74 b5                	je     80103067 <pipewrite+0x44>
        release(&p->lock);
801030b2:	83 ec 0c             	sub    $0xc,%esp
801030b5:	53                   	push   %ebx
801030b6:	e8 49 20 00 00       	call   80105104 <release>
        return -1;
801030bb:	83 c4 10             	add    $0x10,%esp
801030be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801030c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030c6:	5b                   	pop    %ebx
801030c7:	5e                   	pop    %esi
801030c8:	5f                   	pop    %edi
801030c9:	5d                   	pop    %ebp
801030ca:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801030cb:	8d 42 01             	lea    0x1(%edx),%eax
801030ce:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801030d4:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801030da:	8b 45 0c             	mov    0xc(%ebp),%eax
801030dd:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
801030e1:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801030e5:	83 c7 01             	add    $0x1,%edi
801030e8:	e9 56 ff ff ff       	jmp    80103043 <pipewrite+0x20>

801030ed <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801030ed:	f3 0f 1e fb          	endbr32 
801030f1:	55                   	push   %ebp
801030f2:	89 e5                	mov    %esp,%ebp
801030f4:	57                   	push   %edi
801030f5:	56                   	push   %esi
801030f6:	53                   	push   %ebx
801030f7:	83 ec 18             	sub    $0x18,%esp
801030fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801030fd:	89 df                	mov    %ebx,%edi
801030ff:	53                   	push   %ebx
80103100:	e8 96 1f 00 00       	call   8010509b <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103105:	83 c4 10             	add    $0x10,%esp
80103108:	eb 13                	jmp    8010311d <piperead+0x30>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010310a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103110:	83 ec 08             	sub    $0x8,%esp
80103113:	57                   	push   %edi
80103114:	50                   	push   %eax
80103115:	e8 c7 0f 00 00       	call   801040e1 <sleep>
8010311a:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010311d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103123:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103129:	75 28                	jne    80103153 <piperead+0x66>
8010312b:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80103131:	85 f6                	test   %esi,%esi
80103133:	74 23                	je     80103158 <piperead+0x6b>
    if(myproc()->killed){
80103135:	e8 4e 07 00 00       	call   80103888 <myproc>
8010313a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010313e:	74 ca                	je     8010310a <piperead+0x1d>
      release(&p->lock);
80103140:	83 ec 0c             	sub    $0xc,%esp
80103143:	53                   	push   %ebx
80103144:	e8 bb 1f 00 00       	call   80105104 <release>
      return -1;
80103149:	83 c4 10             	add    $0x10,%esp
8010314c:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103151:	eb 50                	jmp    801031a3 <piperead+0xb6>
80103153:	be 00 00 00 00       	mov    $0x0,%esi
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103158:	3b 75 10             	cmp    0x10(%ebp),%esi
8010315b:	7d 2c                	jge    80103189 <piperead+0x9c>
    if(p->nread == p->nwrite)
8010315d:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103163:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103169:	74 1e                	je     80103189 <piperead+0x9c>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010316b:	8d 50 01             	lea    0x1(%eax),%edx
8010316e:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80103174:	25 ff 01 00 00       	and    $0x1ff,%eax
80103179:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
8010317e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103181:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103184:	83 c6 01             	add    $0x1,%esi
80103187:	eb cf                	jmp    80103158 <piperead+0x6b>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103189:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010318f:	83 ec 0c             	sub    $0xc,%esp
80103192:	50                   	push   %eax
80103193:	e8 48 12 00 00       	call   801043e0 <wakeup>
  release(&p->lock);
80103198:	89 1c 24             	mov    %ebx,(%esp)
8010319b:	e8 64 1f 00 00       	call   80105104 <release>
  return i;
801031a0:	83 c4 10             	add    $0x10,%esp
}
801031a3:	89 f0                	mov    %esi,%eax
801031a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031a8:	5b                   	pop    %ebx
801031a9:	5e                   	pop    %esi
801031aa:	5f                   	pop    %edi
801031ab:	5d                   	pop    %ebp
801031ac:	c3                   	ret    

801031ad <stateListAdd>:
#if defined(CS333_P3)
// list management helper functions
static void
stateListAdd(struct ptrs* list, struct proc* p)
{
  if((*list).head == NULL){
801031ad:	83 38 00             	cmpl   $0x0,(%eax)
801031b0:	74 20                	je     801031d2 <stateListAdd+0x25>
    (*list).head = p;
    (*list).tail = p;
    p->next = NULL;
  } else{
    ((*list).tail)->next = p;
801031b2:	8b 48 04             	mov    0x4(%eax),%ecx
801031b5:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
    (*list).tail = ((*list).tail)->next;
801031bb:	8b 50 04             	mov    0x4(%eax),%edx
801031be:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
801031c4:	89 50 04             	mov    %edx,0x4(%eax)
    ((*list).tail)->next = NULL;
801031c7:	c7 82 90 00 00 00 00 	movl   $0x0,0x90(%edx)
801031ce:	00 00 00 
  }
}
801031d1:	c3                   	ret    
    (*list).head = p;
801031d2:	89 10                	mov    %edx,(%eax)
    (*list).tail = p;
801031d4:	89 50 04             	mov    %edx,0x4(%eax)
    p->next = NULL;
801031d7:	c7 82 90 00 00 00 00 	movl   $0x0,0x90(%edx)
801031de:	00 00 00 
801031e1:	c3                   	ret    

801031e2 <stateListRemove>:

#if defined(CS333_P3)
static int
stateListRemove(struct ptrs* list, struct proc* p)
{
  if((*list).head == NULL || (*list).tail == NULL || p == NULL){
801031e2:	8b 08                	mov    (%eax),%ecx
801031e4:	85 c9                	test   %ecx,%ecx
801031e6:	74 7d                	je     80103265 <stateListRemove+0x83>
{
801031e8:	55                   	push   %ebp
801031e9:	89 e5                	mov    %esp,%ebp
801031eb:	56                   	push   %esi
801031ec:	53                   	push   %ebx
  if((*list).head == NULL || (*list).tail == NULL || p == NULL){
801031ed:	8b 70 04             	mov    0x4(%eax),%esi
801031f0:	85 f6                	test   %esi,%esi
801031f2:	74 77                	je     8010326b <stateListRemove+0x89>
801031f4:	85 d2                	test   %edx,%edx
801031f6:	74 7a                	je     80103272 <stateListRemove+0x90>
  }

  struct proc* current = (*list).head;
  struct proc* previous = 0;

  if(current == p){
801031f8:	39 d1                	cmp    %edx,%ecx
801031fa:	74 17                	je     80103213 <stateListRemove+0x31>
  struct proc* previous = 0;
801031fc:	bb 00 00 00 00       	mov    $0x0,%ebx
      (*list).tail = NULL;
    }
    return 0;
  }

  while(current){
80103201:	85 c9                	test   %ecx,%ecx
80103203:	74 2a                	je     8010322f <stateListRemove+0x4d>
    if(current == p){
80103205:	39 d1                	cmp    %edx,%ecx
80103207:	74 26                	je     8010322f <stateListRemove+0x4d>
      break;
    }

    previous = current;
80103209:	89 cb                	mov    %ecx,%ebx
    current = current->next;
8010320b:	8b 89 90 00 00 00    	mov    0x90(%ecx),%ecx
80103211:	eb ee                	jmp    80103201 <stateListRemove+0x1f>
    (*list).head = ((*list).head)->next;
80103213:	8b 89 90 00 00 00    	mov    0x90(%ecx),%ecx
80103219:	89 08                	mov    %ecx,(%eax)
    if((*list).tail == p){
8010321b:	39 d6                	cmp    %edx,%esi
8010321d:	74 07                	je     80103226 <stateListRemove+0x44>
    return 0;
8010321f:	b8 00 00 00 00       	mov    $0x0,%eax
80103224:	eb 2c                	jmp    80103252 <stateListRemove+0x70>
      (*list).tail = NULL;
80103226:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
8010322d:	eb f0                	jmp    8010321f <stateListRemove+0x3d>
  }

  // Process not found. return error
  if(current == NULL){
8010322f:	85 c9                	test   %ecx,%ecx
80103231:	74 46                	je     80103279 <stateListRemove+0x97>
    return -1;
  }

  // Process found.
  if(current == (*list).tail){
80103233:	39 ce                	cmp    %ecx,%esi
80103235:	74 1f                	je     80103256 <stateListRemove+0x74>
    (*list).tail = previous;
    ((*list).tail)->next = NULL;
  } else{
    previous->next = current->next;
80103237:	8b 81 90 00 00 00    	mov    0x90(%ecx),%eax
8010323d:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  }

  // Make sure p->next doesn't point into the list.
  p->next = NULL;
80103243:	c7 82 90 00 00 00 00 	movl   $0x0,0x90(%edx)
8010324a:	00 00 00 

  return 0;
8010324d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103252:	5b                   	pop    %ebx
80103253:	5e                   	pop    %esi
80103254:	5d                   	pop    %ebp
80103255:	c3                   	ret    
    (*list).tail = previous;
80103256:	89 58 04             	mov    %ebx,0x4(%eax)
    ((*list).tail)->next = NULL;
80103259:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80103260:	00 00 00 
80103263:	eb de                	jmp    80103243 <stateListRemove+0x61>
    return -1;
80103265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010326a:	c3                   	ret    
    return -1;
8010326b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103270:	eb e0                	jmp    80103252 <stateListRemove+0x70>
80103272:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103277:	eb d9                	jmp    80103252 <stateListRemove+0x70>
    return -1;
80103279:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010327e:	eb d2                	jmp    80103252 <stateListRemove+0x70>

80103280 <initProcessLists>:
static void
initProcessLists()
{
  int i;

  for (i = UNUSED; i <= ZOMBIE; i++) {
80103280:	b8 00 00 00 00       	mov    $0x0,%eax
80103285:	83 f8 05             	cmp    $0x5,%eax
80103288:	7f 21                	jg     801032ab <initProcessLists+0x2b>
    ptable.list[i].head = NULL;
8010328a:	8d 90 e6 04 00 00    	lea    0x4e6(%eax),%edx
80103290:	c7 04 d5 e4 b5 10 80 	movl   $0x0,-0x7fef4a1c(,%edx,8)
80103297:	00 00 00 00 
    ptable.list[i].tail = NULL;
8010329b:	c7 04 d5 e8 b5 10 80 	movl   $0x0,-0x7fef4a18(,%edx,8)
801032a2:	00 00 00 00 
  for (i = UNUSED; i <= ZOMBIE; i++) {
801032a6:	83 c0 01             	add    $0x1,%eax
801032a9:	eb da                	jmp    80103285 <initProcessLists+0x5>
  }
#if defined(CS333_P4)
  for (i = 0; i <= MAXPRIO; i++) {
801032ab:	b8 00 00 00 00       	mov    $0x0,%eax
801032b0:	eb 1f                	jmp    801032d1 <initProcessLists+0x51>
    ptable.ready[i].head = NULL;
801032b2:	8d 90 ec 04 00 00    	lea    0x4ec(%eax),%edx
801032b8:	c7 04 d5 e4 b5 10 80 	movl   $0x0,-0x7fef4a1c(,%edx,8)
801032bf:	00 00 00 00 
    ptable.ready[i].tail = NULL;
801032c3:	c7 04 d5 e8 b5 10 80 	movl   $0x0,-0x7fef4a18(,%edx,8)
801032ca:	00 00 00 00 
  for (i = 0; i <= MAXPRIO; i++) {
801032ce:	83 c0 01             	add    $0x1,%eax
801032d1:	83 f8 06             	cmp    $0x6,%eax
801032d4:	7e dc                	jle    801032b2 <initProcessLists+0x32>
  }
#endif
}
801032d6:	c3                   	ret    

801032d7 <initFreeList>:
#endif

#if defined(CS333_P3)
static void
initFreeList(void)
{
801032d7:	55                   	push   %ebp
801032d8:	89 e5                	mov    %esp,%ebp
801032da:	53                   	push   %ebx
801032db:	83 ec 04             	sub    $0x4,%esp
  struct proc* p;

  for(p = ptable.proc; p < ptable.proc + NPROC; ++p){
801032de:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
801032e3:	eb 19                	jmp    801032fe <initFreeList+0x27>
    p->state = UNUSED;
801032e5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    stateListAdd(&ptable.list[UNUSED], p);
801032ec:	89 da                	mov    %ebx,%edx
801032ee:	b8 14 dd 10 80       	mov    $0x8010dd14,%eax
801032f3:	e8 b5 fe ff ff       	call   801031ad <stateListAdd>
  for(p = ptable.proc; p < ptable.proc + NPROC; ++p){
801032f8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801032fe:	81 fb 14 dd 10 80    	cmp    $0x8010dd14,%ebx
80103304:	72 df                	jb     801032e5 <initFreeList+0xe>
  }
}
80103306:	83 c4 04             	add    $0x4,%esp
80103309:	5b                   	pop    %ebx
8010330a:	5d                   	pop    %ebp
8010330b:	c3                   	ret    

8010330c <promote_prio>:
  return -1;
}

static void
promote_prio(void)
{
8010330c:	55                   	push   %ebp
8010330d:	89 e5                	mov    %esp,%ebp
8010330f:	57                   	push   %edi
80103310:	56                   	push   %esi
80103311:	53                   	push   %ebx
80103312:	83 ec 0c             	sub    $0xc,%esp
  struct proc * p;
  struct proc * temp;
  p = ptable.list[SLEEPING].head;
80103315:	a1 24 dd 10 80       	mov    0x8010dd24,%eax
  while(p != NULL) {
8010331a:	eb 06                	jmp    80103322 <promote_prio+0x16>
    if(p->priority < MAXPRIO && p->priority >= 0) {
      ++p->priority;
      p->budget = BUDGET;
    }
    p = p->next;
8010331c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  while(p != NULL) {
80103322:	85 c0                	test   %eax,%eax
80103324:	74 20                	je     80103346 <promote_prio+0x3a>
    if(p->priority < MAXPRIO && p->priority >= 0) {
80103326:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
8010332c:	83 fa 05             	cmp    $0x5,%edx
8010332f:	77 eb                	ja     8010331c <promote_prio+0x10>
      ++p->priority;
80103331:	83 c2 01             	add    $0x1,%edx
80103334:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      p->budget = BUDGET;
8010333a:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80103341:	01 00 00 
80103344:	eb d6                	jmp    8010331c <promote_prio+0x10>
  }

  p = ptable.list[RUNNING].head;
80103346:	a1 34 dd 10 80       	mov    0x8010dd34,%eax
  while(p != NULL) {
8010334b:	eb 06                	jmp    80103353 <promote_prio+0x47>
    if(p->priority < MAXPRIO && p->priority >= 0) {
      ++p->priority;
      p->budget = BUDGET;
    }
    p = p->next;
8010334d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  while(p != NULL) {
80103353:	85 c0                	test   %eax,%eax
80103355:	74 20                	je     80103377 <promote_prio+0x6b>
    if(p->priority < MAXPRIO && p->priority >= 0) {
80103357:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
8010335d:	83 fa 05             	cmp    $0x5,%edx
80103360:	77 eb                	ja     8010334d <promote_prio+0x41>
      ++p->priority;
80103362:	83 c2 01             	add    $0x1,%edx
80103365:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      p->budget = BUDGET;
8010336b:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80103372:	01 00 00 
80103375:	eb d6                	jmp    8010334d <promote_prio+0x41>
  }

  for(int i = MAXPRIO - 1; i >= 0 ; --i) {
80103377:	be 05 00 00 00       	mov    $0x5,%esi
8010337c:	eb 10                	jmp    8010338e <promote_prio+0x82>
    p = ptable.ready[i].head;
    while(p != NULL) {
      temp = p -> next;
      if(stateListRemove(&ptable.ready[i], p) == -1) {
        panic("failure to remove process from READY list in promote()\n");
8010337e:	83 ec 0c             	sub    $0xc,%esp
80103381:	68 40 81 10 80       	push   $0x80108140
80103386:	e8 d1 cf ff ff       	call   8010035c <panic>
  for(int i = MAXPRIO - 1; i >= 0 ; --i) {
8010338b:	83 ee 01             	sub    $0x1,%esi
8010338e:	85 f6                	test   %esi,%esi
80103390:	78 4f                	js     801033e1 <promote_prio+0xd5>
    p = ptable.ready[i].head;
80103392:	8b 1c f5 44 dd 10 80 	mov    -0x7fef22bc(,%esi,8),%ebx
    while(p != NULL) {
80103399:	85 db                	test   %ebx,%ebx
8010339b:	74 ee                	je     8010338b <promote_prio+0x7f>
      temp = p -> next;
8010339d:	8b bb 90 00 00 00    	mov    0x90(%ebx),%edi
      if(stateListRemove(&ptable.ready[i], p) == -1) {
801033a3:	8d 04 f5 44 dd 10 80 	lea    -0x7fef22bc(,%esi,8),%eax
801033aa:	89 da                	mov    %ebx,%edx
801033ac:	e8 31 fe ff ff       	call   801031e2 <stateListRemove>
801033b1:	83 f8 ff             	cmp    $0xffffffff,%eax
801033b4:	74 c8                	je     8010337e <promote_prio+0x72>
      }
      ++p->priority;
801033b6:	8b 83 94 00 00 00    	mov    0x94(%ebx),%eax
801033bc:	83 c0 01             	add    $0x1,%eax
801033bf:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
      p->budget = BUDGET;
801033c5:	c7 83 98 00 00 00 2c 	movl   $0x12c,0x98(%ebx)
801033cc:	01 00 00 
      stateListAdd(&ptable.ready[i+1], p);	
801033cf:	8d 04 f5 4c dd 10 80 	lea    -0x7fef22b4(,%esi,8),%eax
801033d6:	89 da                	mov    %ebx,%edx
801033d8:	e8 d0 fd ff ff       	call   801031ad <stateListAdd>
      p = temp;
801033dd:	89 fb                	mov    %edi,%ebx
801033df:	eb b8                	jmp    80103399 <promote_prio+0x8d>
    }
  }
}
801033e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033e4:	5b                   	pop    %ebx
801033e5:	5e                   	pop    %esi
801033e6:	5f                   	pop    %edi
801033e7:	5d                   	pop    %ebp
801033e8:	c3                   	ret    

801033e9 <assertState>:
    if (p->state == state)
801033e9:	8b 40 0c             	mov    0xc(%eax),%eax
801033ec:	39 d0                	cmp    %edx,%eax
801033ee:	75 01                	jne    801033f1 <assertState+0x8>
801033f0:	c3                   	ret    
{
801033f1:	55                   	push   %ebp
801033f2:	89 e5                	mov    %esp,%ebp
801033f4:	83 ec 14             	sub    $0x14,%esp
    cprintf("Error: proc state is %s and should be %s.\nCalled from %s line %d\n",
801033f7:	ff 75 08             	pushl  0x8(%ebp)
801033fa:	51                   	push   %ecx
801033fb:	ff 34 95 3c 89 10 80 	pushl  -0x7fef76c4(,%edx,4)
80103402:	ff 34 85 3c 89 10 80 	pushl  -0x7fef76c4(,%eax,4)
80103409:	68 78 81 10 80       	push   $0x80108178
8010340e:	e8 16 d2 ff ff       	call   80100629 <cprintf>
    panic("Error: Process state incorrect in assertState()");
80103413:	83 c4 14             	add    $0x14,%esp
80103416:	68 bc 81 10 80       	push   $0x801081bc
8010341b:	e8 3c cf ff ff       	call   8010035c <panic>

80103420 <allocproc>:
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	56                   	push   %esi
80103424:	53                   	push   %ebx
  acquire(&ptable.lock);
80103425:	83 ec 0c             	sub    $0xc,%esp
80103428:	68 e0 b5 10 80       	push   $0x8010b5e0
8010342d:	e8 69 1c 00 00       	call   8010509b <acquire>
  if(ptable.list[UNUSED].head){
80103432:	8b 1d 14 dd 10 80    	mov    0x8010dd14,%ebx
80103438:	83 c4 10             	add    $0x10,%esp
8010343b:	85 db                	test   %ebx,%ebx
8010343d:	0f 84 e2 00 00 00    	je     80103525 <allocproc+0x105>
    if(stateListRemove(&ptable.list[UNUSED], p) == -1) {
80103443:	89 da                	mov    %ebx,%edx
80103445:	b8 14 dd 10 80       	mov    $0x8010dd14,%eax
8010344a:	e8 93 fd ff ff       	call   801031e2 <stateListRemove>
8010344f:	83 f8 ff             	cmp    $0xffffffff,%eax
80103452:	0f 84 df 00 00 00    	je     80103537 <allocproc+0x117>
    assertState(p, UNUSED, __FUNCTION__, __LINE__);
80103458:	83 ec 0c             	sub    $0xc,%esp
8010345b:	68 a1 00 00 00       	push   $0xa1
80103460:	b9 24 89 10 80       	mov    $0x80108924,%ecx
80103465:	ba 00 00 00 00       	mov    $0x0,%edx
8010346a:	89 d8                	mov    %ebx,%eax
8010346c:	e8 78 ff ff ff       	call   801033e9 <assertState>
  p->state = EMBRYO;
80103471:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  stateListAdd(&ptable.list[EMBRYO], p);
80103478:	89 da                	mov    %ebx,%edx
8010347a:	b8 1c dd 10 80       	mov    $0x8010dd1c,%eax
8010347f:	e8 29 fd ff ff       	call   801031ad <stateListAdd>
  p->pid = nextpid++;
80103484:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80103489:	8d 50 01             	lea    0x1(%eax),%edx
8010348c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80103492:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103495:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010349c:	e8 63 1c 00 00       	call   80105104 <release>
  if((p->kstack = kalloc()) == 0){
801034a1:	e8 5d ed ff ff       	call   80102203 <kalloc>
801034a6:	89 c6                	mov    %eax,%esi
801034a8:	89 43 08             	mov    %eax,0x8(%ebx)
801034ab:	83 c4 10             	add    $0x10,%esp
801034ae:	85 c0                	test   %eax,%eax
801034b0:	0f 84 8e 00 00 00    	je     80103544 <allocproc+0x124>
  sp -= sizeof *p->tf;
801034b6:	8d 80 b4 0f 00 00    	lea    0xfb4(%eax),%eax
  p->tf = (struct trapframe*)sp;
801034bc:	89 43 18             	mov    %eax,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801034bf:	c7 86 b0 0f 00 00 27 	movl   $0x80106427,0xfb0(%esi)
801034c6:	64 10 80 
  sp -= sizeof *p->context;
801034c9:	81 c6 9c 0f 00 00    	add    $0xf9c,%esi
  p->context = (struct context*)sp;
801034cf:	89 73 1c             	mov    %esi,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801034d2:	83 ec 04             	sub    $0x4,%esp
801034d5:	6a 14                	push   $0x14
801034d7:	6a 00                	push   $0x0
801034d9:	56                   	push   %esi
801034da:	e8 70 1c 00 00       	call   8010514f <memset>
  p->context->eip = (uint)forkret;
801034df:	8b 43 1c             	mov    0x1c(%ebx),%eax
801034e2:	c7 40 10 a4 37 10 80 	movl   $0x801037a4,0x10(%eax)
  p->start_ticks = ticks; 
801034e9:	a1 00 6d 11 80       	mov    0x80116d00,%eax
801034ee:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->cpu_ticks_total = 0;
801034f1:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
801034f8:	00 00 00 
  p->cpu_ticks_in = 0;
801034fb:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103502:	00 00 00 
  p->priority = MAXPRIO;
80103505:	c7 83 94 00 00 00 06 	movl   $0x6,0x94(%ebx)
8010350c:	00 00 00 
  p->budget = BUDGET;
8010350f:	c7 83 98 00 00 00 2c 	movl   $0x12c,0x98(%ebx)
80103516:	01 00 00 
  return p;
80103519:	83 c4 10             	add    $0x10,%esp
}
8010351c:	89 d8                	mov    %ebx,%eax
8010351e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103521:	5b                   	pop    %ebx
80103522:	5e                   	pop    %esi
80103523:	5d                   	pop    %ebp
80103524:	c3                   	ret    
    release(&ptable.lock);
80103525:	83 ec 0c             	sub    $0xc,%esp
80103528:	68 e0 b5 10 80       	push   $0x8010b5e0
8010352d:	e8 d2 1b 00 00       	call   80105104 <release>
    return 0;
80103532:	83 c4 10             	add    $0x10,%esp
80103535:	eb e5                	jmp    8010351c <allocproc+0xfc>
      panic("failure to remove UNUSED from allocproc()");
80103537:	83 ec 0c             	sub    $0xc,%esp
8010353a:	68 ec 81 10 80       	push   $0x801081ec
8010353f:	e8 18 ce ff ff       	call   8010035c <panic>
    acquire(&ptable.lock);
80103544:	83 ec 0c             	sub    $0xc,%esp
80103547:	68 e0 b5 10 80       	push   $0x8010b5e0
8010354c:	e8 4a 1b 00 00       	call   8010509b <acquire>
    if(stateListRemove(&ptable.list[EMBRYO], p) == -1){
80103551:	89 da                	mov    %ebx,%edx
80103553:	b8 1c dd 10 80       	mov    $0x8010dd1c,%eax
80103558:	e8 85 fc ff ff       	call   801031e2 <stateListRemove>
8010355d:	83 c4 10             	add    $0x10,%esp
80103560:	83 f8 ff             	cmp    $0xffffffff,%eax
80103563:	74 42                	je     801035a7 <allocproc+0x187>
    assertState(p, EMBRYO, __FUNCTION__, __LINE__);
80103565:	83 ec 0c             	sub    $0xc,%esp
80103568:	68 b2 00 00 00       	push   $0xb2
8010356d:	b9 24 89 10 80       	mov    $0x80108924,%ecx
80103572:	ba 01 00 00 00       	mov    $0x1,%edx
80103577:	89 d8                	mov    %ebx,%eax
80103579:	e8 6b fe ff ff       	call   801033e9 <assertState>
    p->state = UNUSED;
8010357e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    stateListAdd(&ptable.list[UNUSED], p);
80103585:	89 da                	mov    %ebx,%edx
80103587:	b8 14 dd 10 80       	mov    $0x8010dd14,%eax
8010358c:	e8 1c fc ff ff       	call   801031ad <stateListAdd>
    release(&ptable.lock);
80103591:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80103598:	e8 67 1b 00 00       	call   80105104 <release>
    return 0;
8010359d:	83 c4 10             	add    $0x10,%esp
801035a0:	89 f3                	mov    %esi,%ebx
801035a2:	e9 75 ff ff ff       	jmp    8010351c <allocproc+0xfc>
      panic("failed to remove from EMBRYO list after kernel stack allocation failure in allocproc()");
801035a7:	83 ec 0c             	sub    $0xc,%esp
801035aa:	68 18 82 10 80       	push   $0x80108218
801035af:	e8 a8 cd ff ff       	call   8010035c <panic>

801035b4 <wakeup1>:
{
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	57                   	push   %edi
801035b8:	56                   	push   %esi
801035b9:	53                   	push   %ebx
801035ba:	83 ec 0c             	sub    $0xc,%esp
801035bd:	89 c6                	mov    %eax,%esi
  current = ptable.list[SLEEPING].head;
801035bf:	8b 1d 24 dd 10 80    	mov    0x8010dd24,%ebx
  while(current != NULL) {
801035c5:	eb 50                	jmp    80103617 <wakeup1+0x63>
      current = current->next;
801035c7:	8b bb 90 00 00 00    	mov    0x90(%ebx),%edi
      if(stateListRemove(&ptable.list[SLEEPING], p) == -1) {
801035cd:	89 da                	mov    %ebx,%edx
801035cf:	b8 24 dd 10 80       	mov    $0x8010dd24,%eax
801035d4:	e8 09 fc ff ff       	call   801031e2 <stateListRemove>
801035d9:	83 f8 ff             	cmp    $0xffffffff,%eax
801035dc:	74 4a                	je     80103628 <wakeup1+0x74>
      assertState(p, SLEEPING, __FUNCTION__, __LINE__);
801035de:	83 ec 0c             	sub    $0xc,%esp
801035e1:	68 dc 03 00 00       	push   $0x3dc
801035e6:	b9 0c 89 10 80       	mov    $0x8010890c,%ecx
801035eb:	ba 02 00 00 00       	mov    $0x2,%edx
801035f0:	89 d8                	mov    %ebx,%eax
801035f2:	e8 f2 fd ff ff       	call   801033e9 <assertState>
      p->state = RUNNABLE;
801035f7:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
      stateListAdd(&ptable.ready[p->priority], p);
801035fe:	8b 83 94 00 00 00    	mov    0x94(%ebx),%eax
80103604:	8d 04 c5 44 dd 10 80 	lea    -0x7fef22bc(,%eax,8),%eax
8010360b:	89 da                	mov    %ebx,%edx
8010360d:	e8 9b fb ff ff       	call   801031ad <stateListAdd>
80103612:	83 c4 10             	add    $0x10,%esp
      current = current->next;
80103615:	89 fb                	mov    %edi,%ebx
  while(current != NULL) {
80103617:	85 db                	test   %ebx,%ebx
80103619:	74 1a                	je     80103635 <wakeup1+0x81>
    if(current->chan == chan) {
8010361b:	39 73 20             	cmp    %esi,0x20(%ebx)
8010361e:	74 a7                	je     801035c7 <wakeup1+0x13>
      current = current->next;
80103620:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
80103626:	eb ef                	jmp    80103617 <wakeup1+0x63>
        panic("failed to remove SLEEPING from wakeup1()");
80103628:	83 ec 0c             	sub    $0xc,%esp
8010362b:	68 70 82 10 80       	push   $0x80108270
80103630:	e8 27 cd ff ff       	call   8010035c <panic>
}
80103635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103638:	5b                   	pop    %ebx
80103639:	5e                   	pop    %esi
8010363a:	5f                   	pop    %edi
8010363b:	5d                   	pop    %ebp
8010363c:	c3                   	ret    

8010363d <assert_prio>:

static void
assert_prio(struct proc * p, int priority) 
{
  if(p->priority != priority) {
8010363d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80103643:	39 d0                	cmp    %edx,%eax
80103645:	75 01                	jne    80103648 <assert_prio+0xb>
80103647:	c3                   	ret    
{
80103648:	55                   	push   %ebp
80103649:	89 e5                	mov    %esp,%ebp
8010364b:	83 ec 0c             	sub    $0xc,%esp
    cprintf("failure, p->priority is %s and p->priority should be %s", p->priority, priority);
8010364e:	52                   	push   %edx
8010364f:	50                   	push   %eax
80103650:	68 9c 82 10 80       	push   $0x8010829c
80103655:	e8 cf cf ff ff       	call   80100629 <cprintf>
    panic("Kernel panic\n");
8010365a:	c7 04 24 08 87 10 80 	movl   $0x80108708,(%esp)
80103661:	e8 f6 cc ff ff       	call   8010035c <panic>

80103666 <printReadyList>:
{
80103666:	55                   	push   %ebp
80103667:	89 e5                	mov    %esp,%ebp
80103669:	57                   	push   %edi
8010366a:	56                   	push   %esi
8010366b:	53                   	push   %ebx
8010366c:	83 ec 0c             	sub    $0xc,%esp
  if (p == NULL) {
8010366f:	85 c0                	test   %eax,%eax
80103671:	74 0b                	je     8010367e <printReadyList+0x18>
80103673:	89 c3                	mov    %eax,%ebx
80103675:	89 d7                	mov    %edx,%edi
  int count = 0;
80103677:	be 00 00 00 00       	mov    $0x0,%esi
8010367c:	eb 47                	jmp    801036c5 <printReadyList+0x5f>
    cprintf("(NULL)\n");
8010367e:	83 ec 0c             	sub    $0xc,%esp
80103681:	68 1b 87 10 80       	push   $0x8010871b
80103686:	e8 9e cf ff ff       	call   80100629 <cprintf>
    return;
8010368b:	83 c4 10             	add    $0x10,%esp
}
8010368e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103691:	5b                   	pop    %ebx
80103692:	5e                   	pop    %esi
80103693:	5f                   	pop    %edi
80103694:	5d                   	pop    %ebp
80103695:	c3                   	ret    
      cprintf("\nlist invariant failed: process %d has prio %d but is on runnable list %d\n",
80103696:	57                   	push   %edi
80103697:	50                   	push   %eax
80103698:	ff 73 10             	pushl  0x10(%ebx)
8010369b:	68 d4 82 10 80       	push   $0x801082d4
801036a0:	e8 84 cf ff ff       	call   80100629 <cprintf>
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	eb 3e                	jmp    801036e8 <printReadyList+0x82>
    cprintf("%s", p ? " -> " : "\n");
801036aa:	b8 7b 8c 10 80       	mov    $0x80108c7b,%eax
801036af:	eb 46                	jmp    801036f7 <printReadyList+0x91>
      cprintf("\n");
801036b1:	83 ec 0c             	sub    $0xc,%esp
801036b4:	68 7b 8c 10 80       	push   $0x80108c7b
801036b9:	e8 6b cf ff ff       	call   80100629 <cprintf>
801036be:	83 c4 10             	add    $0x10,%esp
  } while (p != NULL);
801036c1:	85 db                	test   %ebx,%ebx
801036c3:	74 c9                	je     8010368e <printReadyList+0x28>
    cprintf("%d,%d", p->pid, p->budget);
801036c5:	83 ec 04             	sub    $0x4,%esp
801036c8:	ff b3 98 00 00 00    	pushl  0x98(%ebx)
801036ce:	ff 73 10             	pushl  0x10(%ebx)
801036d1:	68 23 87 10 80       	push   $0x80108723
801036d6:	e8 4e cf ff ff       	call   80100629 <cprintf>
    if(p->priority != prio) {
801036db:	8b 83 94 00 00 00    	mov    0x94(%ebx),%eax
801036e1:	83 c4 10             	add    $0x10,%esp
801036e4:	39 f8                	cmp    %edi,%eax
801036e6:	75 ae                	jne    80103696 <printReadyList+0x30>
    p = p->next;
801036e8:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
    cprintf("%s", p ? " -> " : "\n");
801036ee:	85 db                	test   %ebx,%ebx
801036f0:	74 b8                	je     801036aa <printReadyList+0x44>
801036f2:	b8 16 87 10 80       	mov    $0x80108716,%eax
801036f7:	83 ec 08             	sub    $0x8,%esp
801036fa:	50                   	push   %eax
801036fb:	68 29 87 10 80       	push   $0x80108729
80103700:	e8 24 cf ff ff       	call   80100629 <cprintf>
    if (p && (++count) % PER_LINE == 0)
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	85 db                	test   %ebx,%ebx
8010370a:	74 b5                	je     801036c1 <printReadyList+0x5b>
8010370c:	83 c6 01             	add    $0x1,%esi
8010370f:	ba 89 88 88 88       	mov    $0x88888889,%edx
80103714:	89 f0                	mov    %esi,%eax
80103716:	f7 ea                	imul   %edx
80103718:	01 f2                	add    %esi,%edx
8010371a:	c1 fa 03             	sar    $0x3,%edx
8010371d:	89 f0                	mov    %esi,%eax
8010371f:	c1 f8 1f             	sar    $0x1f,%eax
80103722:	29 c2                	sub    %eax,%edx
80103724:	89 d0                	mov    %edx,%eax
80103726:	c1 e0 04             	shl    $0x4,%eax
80103729:	29 d0                	sub    %edx,%eax
8010372b:	39 c6                	cmp    %eax,%esi
8010372d:	75 92                	jne    801036c1 <printReadyList+0x5b>
8010372f:	eb 80                	jmp    801036b1 <printReadyList+0x4b>

80103731 <printReadyLists>:
{
80103731:	55                   	push   %ebp
80103732:	89 e5                	mov    %esp,%ebp
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
  cprintf("Ready List Processes:\n");
80103736:	83 ec 0c             	sub    $0xc,%esp
80103739:	68 2c 87 10 80       	push   $0x8010872c
8010373e:	e8 e6 ce ff ff       	call   80100629 <cprintf>
  for (int i=MAXPRIO; i>=PRIO_MIN; i--) {
80103743:	83 c4 10             	add    $0x10,%esp
80103746:	bb 06 00 00 00       	mov    $0x6,%ebx
8010374b:	eb 26                	jmp    80103773 <printReadyLists+0x42>
        cprintf("\nlist invariant failed: process %d has state %s but is on ready list\n",
8010374d:	83 ec 04             	sub    $0x4,%esp
80103750:	ff 34 85 3c 89 10 80 	pushl  -0x7fef76c4(,%eax,4)
80103757:	ff 76 10             	pushl  0x10(%esi)
8010375a:	68 20 83 10 80       	push   $0x80108320
8010375f:	e8 c5 ce ff ff       	call   80100629 <cprintf>
80103764:	83 c4 10             	add    $0x10,%esp
    printReadyList(p, i);
80103767:	89 da                	mov    %ebx,%edx
80103769:	89 f0                	mov    %esi,%eax
8010376b:	e8 f6 fe ff ff       	call   80103666 <printReadyList>
  for (int i=MAXPRIO; i>=PRIO_MIN; i--) {
80103770:	83 eb 01             	sub    $0x1,%ebx
80103773:	85 db                	test   %ebx,%ebx
80103775:	78 26                	js     8010379d <printReadyLists+0x6c>
    p = ptable.ready[i].head;
80103777:	8b 34 dd 44 dd 10 80 	mov    -0x7fef22bc(,%ebx,8),%esi
    if(p != NULL){
8010377e:	85 f6                	test   %esi,%esi
80103780:	74 e5                	je     80103767 <printReadyLists+0x36>
      cprintf("Prio %d: ", i);
80103782:	83 ec 08             	sub    $0x8,%esp
80103785:	53                   	push   %ebx
80103786:	68 43 87 10 80       	push   $0x80108743
8010378b:	e8 99 ce ff ff       	call   80100629 <cprintf>
      if(p->state != RUNNABLE) {
80103790:	8b 46 0c             	mov    0xc(%esi),%eax
80103793:	83 c4 10             	add    $0x10,%esp
80103796:	83 f8 03             	cmp    $0x3,%eax
80103799:	74 cc                	je     80103767 <printReadyLists+0x36>
8010379b:	eb b0                	jmp    8010374d <printReadyLists+0x1c>
}
8010379d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037a0:	5b                   	pop    %ebx
801037a1:	5e                   	pop    %esi
801037a2:	5d                   	pop    %ebp
801037a3:	c3                   	ret    

801037a4 <forkret>:
{
801037a4:	f3 0f 1e fb          	endbr32 
801037a8:	55                   	push   %ebp
801037a9:	89 e5                	mov    %esp,%ebp
801037ab:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
801037ae:	68 e0 b5 10 80       	push   $0x8010b5e0
801037b3:	e8 4c 19 00 00       	call   80105104 <release>
  if (first) {
801037b8:	83 c4 10             	add    $0x10,%esp
801037bb:	83 3d 00 b0 10 80 00 	cmpl   $0x0,0x8010b000
801037c2:	75 02                	jne    801037c6 <forkret+0x22>
}
801037c4:	c9                   	leave  
801037c5:	c3                   	ret    
    first = 0;
801037c6:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801037cd:	00 00 00 
    iinit(ROOTDEV);
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	6a 01                	push   $0x1
801037d5:	e8 fc db ff ff       	call   801013d6 <iinit>
    initlog(ROOTDEV);
801037da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037e1:	e8 cd f0 ff ff       	call   801028b3 <initlog>
801037e6:	83 c4 10             	add    $0x10,%esp
}
801037e9:	eb d9                	jmp    801037c4 <forkret+0x20>

801037eb <pinit>:
{
801037eb:	f3 0f 1e fb          	endbr32 
801037ef:	55                   	push   %ebp
801037f0:	89 e5                	mov    %esp,%ebp
801037f2:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037f5:	68 4d 87 10 80       	push   $0x8010874d
801037fa:	68 e0 b5 10 80       	push   $0x8010b5e0
801037ff:	e8 47 17 00 00       	call   80104f4b <initlock>
}
80103804:	83 c4 10             	add    $0x10,%esp
80103807:	c9                   	leave  
80103808:	c3                   	ret    

80103809 <mycpu>:
{
80103809:	f3 0f 1e fb          	endbr32 
8010380d:	55                   	push   %ebp
8010380e:	89 e5                	mov    %esp,%ebp
80103810:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103813:	9c                   	pushf  
80103814:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103815:	f6 c4 02             	test   $0x2,%ah
80103818:	75 28                	jne    80103842 <mycpu+0x39>
  apicid = lapicid();
8010381a:	e8 ab ec ff ff       	call   801024ca <lapicid>
  for (i = 0; i < ncpu; ++i) {
8010381f:	ba 00 00 00 00       	mov    $0x0,%edx
80103824:	39 15 e0 64 11 80    	cmp    %edx,0x801164e0
8010382a:	7e 30                	jle    8010385c <mycpu+0x53>
    if (cpus[i].apicid == apicid) {
8010382c:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103832:	0f b6 89 60 5f 11 80 	movzbl -0x7feea0a0(%ecx),%ecx
80103839:	39 c1                	cmp    %eax,%ecx
8010383b:	74 12                	je     8010384f <mycpu+0x46>
  for (i = 0; i < ncpu; ++i) {
8010383d:	83 c2 01             	add    $0x1,%edx
80103840:	eb e2                	jmp    80103824 <mycpu+0x1b>
    panic("mycpu called with interrupts enabled\n");
80103842:	83 ec 0c             	sub    $0xc,%esp
80103845:	68 68 83 10 80       	push   $0x80108368
8010384a:	e8 0d cb ff ff       	call   8010035c <panic>
      return &cpus[i];
8010384f:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103855:	05 60 5f 11 80       	add    $0x80115f60,%eax
}
8010385a:	c9                   	leave  
8010385b:	c3                   	ret    
  panic("unknown apicid\n");
8010385c:	83 ec 0c             	sub    $0xc,%esp
8010385f:	68 54 87 10 80       	push   $0x80108754
80103864:	e8 f3 ca ff ff       	call   8010035c <panic>

80103869 <cpuid>:
cpuid() {
80103869:	f3 0f 1e fb          	endbr32 
8010386d:	55                   	push   %ebp
8010386e:	89 e5                	mov    %esp,%ebp
80103870:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103873:	e8 91 ff ff ff       	call   80103809 <mycpu>
80103878:	2d 60 5f 11 80       	sub    $0x80115f60,%eax
8010387d:	c1 f8 04             	sar    $0x4,%eax
80103880:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103886:	c9                   	leave  
80103887:	c3                   	ret    

80103888 <myproc>:
myproc(void) {
80103888:	f3 0f 1e fb          	endbr32 
8010388c:	55                   	push   %ebp
8010388d:	89 e5                	mov    %esp,%ebp
8010388f:	53                   	push   %ebx
80103890:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103893:	e8 1a 17 00 00       	call   80104fb2 <pushcli>
  c = mycpu();
80103898:	e8 6c ff ff ff       	call   80103809 <mycpu>
  p = c->proc;
8010389d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038a3:	e8 4b 17 00 00       	call   80104ff3 <popcli>
}
801038a8:	89 d8                	mov    %ebx,%eax
801038aa:	83 c4 04             	add    $0x4,%esp
801038ad:	5b                   	pop    %ebx
801038ae:	5d                   	pop    %ebp
801038af:	c3                   	ret    

801038b0 <userinit>:
{
801038b0:	f3 0f 1e fb          	endbr32 
801038b4:	55                   	push   %ebp
801038b5:	89 e5                	mov    %esp,%ebp
801038b7:	53                   	push   %ebx
801038b8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038bb:	68 e0 b5 10 80       	push   $0x8010b5e0
801038c0:	e8 d6 17 00 00       	call   8010509b <acquire>
  initProcessLists();
801038c5:	e8 b6 f9 ff ff       	call   80103280 <initProcessLists>
  initFreeList();
801038ca:	e8 08 fa ff ff       	call   801032d7 <initFreeList>
  release(&ptable.lock);
801038cf:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801038d6:	e8 29 18 00 00       	call   80105104 <release>
  acquire(&ptable.lock);
801038db:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801038e2:	e8 b4 17 00 00       	call   8010509b <acquire>
  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
801038e7:	a1 00 6d 11 80       	mov    0x80116d00,%eax
801038ec:	05 b8 0b 00 00       	add    $0xbb8,%eax
801038f1:	a3 7c dd 10 80       	mov    %eax,0x8010dd7c
  release(&ptable.lock);
801038f6:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801038fd:	e8 02 18 00 00       	call   80105104 <release>
  p = allocproc();
80103902:	e8 19 fb ff ff       	call   80103420 <allocproc>
80103907:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103909:	a3 c0 b5 10 80       	mov    %eax,0x8010b5c0
  if((p->pgdir = setupkvm()) == 0)
8010390e:	e8 10 40 00 00       	call   80107923 <setupkvm>
80103913:	89 43 04             	mov    %eax,0x4(%ebx)
80103916:	83 c4 10             	add    $0x10,%esp
80103919:	85 c0                	test   %eax,%eax
8010391b:	0f 84 f1 00 00 00    	je     80103a12 <userinit+0x162>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103921:	83 ec 04             	sub    $0x4,%esp
80103924:	68 2c 00 00 00       	push   $0x2c
80103929:	68 60 b4 10 80       	push   $0x8010b460
8010392e:	50                   	push   %eax
8010392f:	e8 ec 3c 00 00       	call   80107620 <inituvm>
  p->sz = PGSIZE;
80103934:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010393a:	8b 43 18             	mov    0x18(%ebx),%eax
8010393d:	83 c4 0c             	add    $0xc,%esp
80103940:	6a 4c                	push   $0x4c
80103942:	6a 00                	push   $0x0
80103944:	50                   	push   %eax
80103945:	e8 05 18 00 00       	call   8010514f <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010394a:	8b 43 18             	mov    0x18(%ebx),%eax
8010394d:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103953:	8b 43 18             	mov    0x18(%ebx),%eax
80103956:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010395c:	8b 43 18             	mov    0x18(%ebx),%eax
8010395f:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103963:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103967:	8b 43 18             	mov    0x18(%ebx),%eax
8010396a:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010396e:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103972:	8b 43 18             	mov    0x18(%ebx),%eax
80103975:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010397c:	8b 43 18             	mov    0x18(%ebx),%eax
8010397f:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103986:	8b 43 18             	mov    0x18(%ebx),%eax
80103989:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103990:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103993:	83 c4 0c             	add    $0xc,%esp
80103996:	6a 10                	push   $0x10
80103998:	68 7d 87 10 80       	push   $0x8010877d
8010399d:	50                   	push   %eax
8010399e:	e8 2c 19 00 00       	call   801052cf <safestrcpy>
  p->cwd = namei("/");
801039a3:	c7 04 24 86 87 10 80 	movl   $0x80108786,(%esp)
801039aa:	e8 51 e3 ff ff       	call   80101d00 <namei>
801039af:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);	//attempts to get the lock; if nobody else is holding it, acquires it and holds it for the process
801039b2:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801039b9:	e8 dd 16 00 00       	call   8010509b <acquire>
  if(stateListRemove(&ptable.list[EMBRYO], p) == -1) {
801039be:	89 da                	mov    %ebx,%edx
801039c0:	b8 1c dd 10 80       	mov    $0x8010dd1c,%eax
801039c5:	e8 18 f8 ff ff       	call   801031e2 <stateListRemove>
801039ca:	83 c4 10             	add    $0x10,%esp
801039cd:	83 f8 ff             	cmp    $0xffffffff,%eax
801039d0:	74 4d                	je     80103a1f <userinit+0x16f>
  assertState(p, EMBRYO, __FUNCTION__, __LINE__);
801039d2:	83 ec 0c             	sub    $0xc,%esp
801039d5:	68 0e 01 00 00       	push   $0x10e
801039da:	b9 30 89 10 80       	mov    $0x80108930,%ecx
801039df:	ba 01 00 00 00       	mov    $0x1,%edx
801039e4:	89 d8                	mov    %ebx,%eax
801039e6:	e8 fe f9 ff ff       	call   801033e9 <assertState>
  p->state = RUNNABLE;
801039eb:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  stateListAdd(&ptable.ready[MAXPRIO], p);
801039f2:	89 da                	mov    %ebx,%edx
801039f4:	b8 74 dd 10 80       	mov    $0x8010dd74,%eax
801039f9:	e8 af f7 ff ff       	call   801031ad <stateListAdd>
  release(&ptable.lock);	//releases the lock so other processes can access ptable
801039fe:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80103a05:	e8 fa 16 00 00       	call   80105104 <release>
}
80103a0a:	83 c4 10             	add    $0x10,%esp
80103a0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a10:	c9                   	leave  
80103a11:	c3                   	ret    
    panic("userinit: out of memory?");
80103a12:	83 ec 0c             	sub    $0xc,%esp
80103a15:	68 64 87 10 80       	push   $0x80108764
80103a1a:	e8 3d c9 ff ff       	call   8010035c <panic>
    panic("failed to remove from EMBYRO list after successful allocation in userinit()");
80103a1f:	83 ec 0c             	sub    $0xc,%esp
80103a22:	68 90 83 10 80       	push   $0x80108390
80103a27:	e8 30 c9 ff ff       	call   8010035c <panic>

80103a2c <growproc>:
{
80103a2c:	f3 0f 1e fb          	endbr32 
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
80103a35:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
80103a38:	e8 4b fe ff ff       	call   80103888 <myproc>
80103a3d:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103a3f:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103a41:	85 f6                	test   %esi,%esi
80103a43:	7f 1c                	jg     80103a61 <growproc+0x35>
  } else if(n < 0){
80103a45:	78 37                	js     80103a7e <growproc+0x52>
  curproc->sz = sz;
80103a47:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a49:	83 ec 0c             	sub    $0xc,%esp
80103a4c:	53                   	push   %ebx
80103a4d:	e8 b2 3a 00 00       	call   80107504 <switchuvm>
  return 0;
80103a52:	83 c4 10             	add    $0x10,%esp
80103a55:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a5d:	5b                   	pop    %ebx
80103a5e:	5e                   	pop    %esi
80103a5f:	5d                   	pop    %ebp
80103a60:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a61:	83 ec 04             	sub    $0x4,%esp
80103a64:	01 c6                	add    %eax,%esi
80103a66:	56                   	push   %esi
80103a67:	50                   	push   %eax
80103a68:	ff 73 04             	pushl  0x4(%ebx)
80103a6b:	e8 52 3d 00 00       	call   801077c2 <allocuvm>
80103a70:	83 c4 10             	add    $0x10,%esp
80103a73:	85 c0                	test   %eax,%eax
80103a75:	75 d0                	jne    80103a47 <growproc+0x1b>
      return -1;
80103a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a7c:	eb dc                	jmp    80103a5a <growproc+0x2e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a7e:	83 ec 04             	sub    $0x4,%esp
80103a81:	01 c6                	add    %eax,%esi
80103a83:	56                   	push   %esi
80103a84:	50                   	push   %eax
80103a85:	ff 73 04             	pushl  0x4(%ebx)
80103a88:	e8 9f 3c 00 00       	call   8010772c <deallocuvm>
80103a8d:	83 c4 10             	add    $0x10,%esp
80103a90:	85 c0                	test   %eax,%eax
80103a92:	75 b3                	jne    80103a47 <growproc+0x1b>
      return -1;
80103a94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a99:	eb bf                	jmp    80103a5a <growproc+0x2e>

80103a9b <fork>:
{
80103a9b:	f3 0f 1e fb          	endbr32 
80103a9f:	55                   	push   %ebp
80103aa0:	89 e5                	mov    %esp,%ebp
80103aa2:	57                   	push   %edi
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
80103aa5:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103aa8:	e8 db fd ff ff       	call   80103888 <myproc>
80103aad:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103aaf:	e8 6c f9 ff ff       	call   80103420 <allocproc>
80103ab4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103ab7:	85 c0                	test   %eax,%eax
80103ab9:	0f 84 a6 01 00 00    	je     80103c65 <fork+0x1ca>
80103abf:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ac1:	83 ec 08             	sub    $0x8,%esp
80103ac4:	ff 33                	pushl  (%ebx)
80103ac6:	ff 73 04             	pushl  0x4(%ebx)
80103ac9:	e8 12 3f 00 00       	call   801079e0 <copyuvm>
80103ace:	89 47 04             	mov    %eax,0x4(%edi)
80103ad1:	83 c4 10             	add    $0x10,%esp
80103ad4:	85 c0                	test   %eax,%eax
80103ad6:	74 2b                	je     80103b03 <fork+0x68>
  np->sz = curproc->sz;
80103ad8:	8b 03                	mov    (%ebx),%eax
80103ada:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103add:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103adf:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103ae2:	8b 73 18             	mov    0x18(%ebx),%esi
80103ae5:	8b 7a 18             	mov    0x18(%edx),%edi
80103ae8:	b9 13 00 00 00       	mov    $0x13,%ecx
80103aed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103aef:	8b 42 18             	mov    0x18(%edx),%eax
80103af2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103af9:	be 00 00 00 00       	mov    $0x0,%esi
80103afe:	e9 a0 00 00 00       	jmp    80103ba3 <fork+0x108>
    kfree(np->kstack);
80103b03:	83 ec 0c             	sub    $0xc,%esp
80103b06:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b09:	ff 73 08             	pushl  0x8(%ebx)
80103b0c:	e8 cb e5 ff ff       	call   801020dc <kfree>
    np->kstack = 0;
80103b11:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    acquire(&ptable.lock);
80103b18:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80103b1f:	e8 77 15 00 00       	call   8010509b <acquire>
    if(stateListRemove(&ptable.list[EMBRYO], np) == -1) {
80103b24:	89 da                	mov    %ebx,%edx
80103b26:	b8 1c dd 10 80       	mov    $0x8010dd1c,%eax
80103b2b:	e8 b2 f6 ff ff       	call   801031e2 <stateListRemove>
80103b30:	83 c4 10             	add    $0x10,%esp
80103b33:	83 f8 ff             	cmp    $0xffffffff,%eax
80103b36:	74 48                	je     80103b80 <fork+0xe5>
    assertState(np, EMBRYO, __FUNCTION__, __LINE__);
80103b38:	83 ec 0c             	sub    $0xc,%esp
80103b3b:	68 45 01 00 00       	push   $0x145
80103b40:	b9 1c 89 10 80       	mov    $0x8010891c,%ecx
80103b45:	ba 01 00 00 00       	mov    $0x1,%edx
80103b4a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b4d:	89 d8                	mov    %ebx,%eax
80103b4f:	e8 95 f8 ff ff       	call   801033e9 <assertState>
    np->state = UNUSED;
80103b54:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    stateListAdd(&ptable.list[UNUSED], np);
80103b5b:	89 da                	mov    %ebx,%edx
80103b5d:	b8 14 dd 10 80       	mov    $0x8010dd14,%eax
80103b62:	e8 46 f6 ff ff       	call   801031ad <stateListAdd>
    release(&ptable.lock);
80103b67:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80103b6e:	e8 91 15 00 00       	call   80105104 <release>
    return -1;
80103b73:	83 c4 10             	add    $0x10,%esp
80103b76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b7b:	e9 d0 00 00 00       	jmp    80103c50 <fork+0x1b5>
      panic("failed to remove from EMBRYO list in fork() after page directory allocation failure");
80103b80:	83 ec 0c             	sub    $0xc,%esp
80103b83:	68 dc 83 10 80       	push   $0x801083dc
80103b88:	e8 cf c7 ff ff       	call   8010035c <panic>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b8d:	83 ec 0c             	sub    $0xc,%esp
80103b90:	50                   	push   %eax
80103b91:	e8 c9 d1 ff ff       	call   80100d5f <filedup>
80103b96:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b99:	89 44 b1 28          	mov    %eax,0x28(%ecx,%esi,4)
80103b9d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
80103ba0:	83 c6 01             	add    $0x1,%esi
80103ba3:	83 fe 0f             	cmp    $0xf,%esi
80103ba6:	7f 0a                	jg     80103bb2 <fork+0x117>
    if(curproc->ofile[i])
80103ba8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bac:	85 c0                	test   %eax,%eax
80103bae:	75 dd                	jne    80103b8d <fork+0xf2>
80103bb0:	eb ee                	jmp    80103ba0 <fork+0x105>
  np->cwd = idup(curproc->cwd);
80103bb2:	83 ec 0c             	sub    $0xc,%esp
80103bb5:	ff 73 68             	pushl  0x68(%ebx)
80103bb8:	e8 8a da ff ff       	call   80101647 <idup>
80103bbd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103bc0:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc3:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103bc6:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bc9:	83 c4 0c             	add    $0xc,%esp
80103bcc:	6a 10                	push   $0x10
80103bce:	52                   	push   %edx
80103bcf:	50                   	push   %eax
80103bd0:	e8 fa 16 00 00       	call   801052cf <safestrcpy>
  pid = np->pid;
80103bd5:	8b 77 10             	mov    0x10(%edi),%esi
  np->uid = curproc->uid;
80103bd8:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103bde:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
  np->gid = curproc->gid;
80103be4:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103bea:	89 87 84 00 00 00    	mov    %eax,0x84(%edi)
  acquire(&ptable.lock);
80103bf0:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80103bf7:	e8 9f 14 00 00       	call   8010509b <acquire>
  if(stateListRemove(&ptable.list[EMBRYO], np) == -1) {
80103bfc:	89 fa                	mov    %edi,%edx
80103bfe:	b8 1c dd 10 80       	mov    $0x8010dd1c,%eax
80103c03:	e8 da f5 ff ff       	call   801031e2 <stateListRemove>
80103c08:	83 c4 10             	add    $0x10,%esp
80103c0b:	83 f8 ff             	cmp    $0xffffffff,%eax
80103c0e:	74 48                	je     80103c58 <fork+0x1bd>
  assertState(np, EMBRYO, __FUNCTION__, __LINE__);
80103c10:	83 ec 0c             	sub    $0xc,%esp
80103c13:	68 68 01 00 00       	push   $0x168
80103c18:	b9 1c 89 10 80       	mov    $0x8010891c,%ecx
80103c1d:	ba 01 00 00 00       	mov    $0x1,%edx
80103c22:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c25:	89 d8                	mov    %ebx,%eax
80103c27:	e8 bd f7 ff ff       	call   801033e9 <assertState>
  np->state = RUNNABLE;
80103c2c:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  stateListAdd(&ptable.ready[MAXPRIO], np);
80103c33:	89 da                	mov    %ebx,%edx
80103c35:	b8 74 dd 10 80       	mov    $0x8010dd74,%eax
80103c3a:	e8 6e f5 ff ff       	call   801031ad <stateListAdd>
  release(&ptable.lock);
80103c3f:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80103c46:	e8 b9 14 00 00       	call   80105104 <release>
  return pid;
80103c4b:	89 f0                	mov    %esi,%eax
80103c4d:	83 c4 10             	add    $0x10,%esp
}
80103c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c53:	5b                   	pop    %ebx
80103c54:	5e                   	pop    %esi
80103c55:	5f                   	pop    %edi
80103c56:	5d                   	pop    %ebp
80103c57:	c3                   	ret    
    panic("failed to remove from EMBRYO on successful fork");
80103c58:	83 ec 0c             	sub    $0xc,%esp
80103c5b:	68 30 84 10 80       	push   $0x80108430
80103c60:	e8 f7 c6 ff ff       	call   8010035c <panic>
    return -1;
80103c65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c6a:	eb e4                	jmp    80103c50 <fork+0x1b5>

80103c6c <scheduler>:
{
80103c6c:	f3 0f 1e fb          	endbr32 
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	57                   	push   %edi
80103c74:	56                   	push   %esi
80103c75:	53                   	push   %ebx
80103c76:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c79:	e8 8b fb ff ff       	call   80103809 <mycpu>
80103c7e:	89 c7                	mov    %eax,%edi
  c->proc = 0;
80103c80:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c87:	00 00 00 
80103c8a:	e9 d0 00 00 00       	jmp    80103d5f <scheduler+0xf3>
      promote_prio();
80103c8f:	e8 78 f6 ff ff       	call   8010330c <promote_prio>
      ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
80103c94:	a1 00 6d 11 80       	mov    0x80116d00,%eax
80103c99:	05 b8 0b 00 00       	add    $0xbb8,%eax
80103c9e:	a3 7c dd 10 80       	mov    %eax,0x8010dd7c
80103ca3:	e9 d9 00 00 00       	jmp    80103d81 <scheduler+0x115>
        c->proc = p;
80103ca8:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
        switchuvm(p);
80103cae:	83 ec 0c             	sub    $0xc,%esp
80103cb1:	56                   	push   %esi
80103cb2:	e8 4d 38 00 00       	call   80107504 <switchuvm>
        if(stateListRemove(&ptable.ready[i], p) == -1) {
80103cb7:	8d 04 dd 44 dd 10 80 	lea    -0x7fef22bc(,%ebx,8),%eax
80103cbe:	89 f2                	mov    %esi,%edx
80103cc0:	e8 1d f5 ff ff       	call   801031e2 <stateListRemove>
80103cc5:	83 c4 10             	add    $0x10,%esp
80103cc8:	83 f8 ff             	cmp    $0xffffffff,%eax
80103ccb:	75 0d                	jne    80103cda <scheduler+0x6e>
          panic("failed to remove process we will run from RUNNABLE list in scheduler()");
80103ccd:	83 ec 0c             	sub    $0xc,%esp
80103cd0:	68 60 84 10 80       	push   $0x80108460
80103cd5:	e8 82 c6 ff ff       	call   8010035c <panic>
        assertState(p, RUNNABLE, __FUNCTION__, __LINE__);
80103cda:	83 ec 0c             	sub    $0xc,%esp
80103cdd:	68 c0 02 00 00       	push   $0x2c0
80103ce2:	b9 f8 88 10 80       	mov    $0x801088f8,%ecx
80103ce7:	ba 03 00 00 00       	mov    $0x3,%edx
80103cec:	89 f0                	mov    %esi,%eax
80103cee:	e8 f6 f6 ff ff       	call   801033e9 <assertState>
        assert_prio(p, p->priority);
80103cf3:	8b 96 94 00 00 00    	mov    0x94(%esi),%edx
80103cf9:	89 f0                	mov    %esi,%eax
80103cfb:	e8 3d f9 ff ff       	call   8010363d <assert_prio>
        p->state = RUNNING;
80103d00:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
        stateListAdd(&ptable.list[RUNNING], p); 
80103d07:	89 f2                	mov    %esi,%edx
80103d09:	b8 34 dd 10 80       	mov    $0x8010dd34,%eax
80103d0e:	e8 9a f4 ff ff       	call   801031ad <stateListAdd>
        p->cpu_ticks_in = ticks;
80103d13:	a1 00 6d 11 80       	mov    0x80116d00,%eax
80103d18:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
        swtch(&(c->scheduler), p->context);
80103d1e:	83 c4 08             	add    $0x8,%esp
80103d21:	ff 76 1c             	pushl  0x1c(%esi)
80103d24:	8d 47 04             	lea    0x4(%edi),%eax
80103d27:	50                   	push   %eax
80103d28:	e8 ff 15 00 00       	call   8010532c <swtch>
        switchkvm();
80103d2d:	e8 c0 37 00 00       	call   801074f2 <switchkvm>
        c->proc = 0;
80103d32:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80103d39:	00 00 00 
        break;
80103d3c:	83 c4 10             	add    $0x10,%esp
        idle = 0;
80103d3f:	bb 00 00 00 00       	mov    $0x0,%ebx
        break;
80103d44:	eb 05                	jmp    80103d4b <scheduler+0xdf>
    idle = 1;  // assume idle unless we schedule a process
80103d46:	bb 01 00 00 00       	mov    $0x1,%ebx
    release(&ptable.lock);
80103d4b:	83 ec 0c             	sub    $0xc,%esp
80103d4e:	68 e0 b5 10 80       	push   $0x8010b5e0
80103d53:	e8 ac 13 00 00       	call   80105104 <release>
    if (idle) {
80103d58:	83 c4 10             	add    $0x10,%esp
80103d5b:	85 db                	test   %ebx,%ebx
80103d5d:	75 3f                	jne    80103d9e <scheduler+0x132>
  asm volatile("sti");
80103d5f:	fb                   	sti    
    acquire(&ptable.lock);
80103d60:	83 ec 0c             	sub    $0xc,%esp
80103d63:	68 e0 b5 10 80       	push   $0x8010b5e0
80103d68:	e8 2e 13 00 00       	call   8010509b <acquire>
    if(ticks >= ptable.PromoteAtTime) {
80103d6d:	83 c4 10             	add    $0x10,%esp
80103d70:	a1 00 6d 11 80       	mov    0x80116d00,%eax
80103d75:	39 05 7c dd 10 80    	cmp    %eax,0x8010dd7c
80103d7b:	0f 86 0e ff ff ff    	jbe    80103c8f <scheduler+0x23>
    for(int i = MAXPRIO; i >= 0 ; --i) {
80103d81:	bb 06 00 00 00       	mov    $0x6,%ebx
80103d86:	85 db                	test   %ebx,%ebx
80103d88:	78 bc                	js     80103d46 <scheduler+0xda>
      p = ptable.ready[i].head;    
80103d8a:	8b 34 dd 44 dd 10 80 	mov    -0x7fef22bc(,%ebx,8),%esi
      if( p != NULL) {
80103d91:	85 f6                	test   %esi,%esi
80103d93:	0f 85 0f ff ff ff    	jne    80103ca8 <scheduler+0x3c>
    for(int i = MAXPRIO; i >= 0 ; --i) {
80103d99:	83 eb 01             	sub    $0x1,%ebx
80103d9c:	eb e8                	jmp    80103d86 <scheduler+0x11a>
80103d9e:	fb                   	sti    

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
  asm volatile("hlt");
80103d9f:	f4                   	hlt    
}
80103da0:	eb bd                	jmp    80103d5f <scheduler+0xf3>

80103da2 <sched>:
{
80103da2:	f3 0f 1e fb          	endbr32 
80103da6:	55                   	push   %ebp
80103da7:	89 e5                	mov    %esp,%ebp
80103da9:	56                   	push   %esi
80103daa:	53                   	push   %ebx
  struct proc *p = myproc();
80103dab:	e8 d8 fa ff ff       	call   80103888 <myproc>
80103db0:	89 c3                	mov    %eax,%ebx
  p->cpu_ticks_total = (p->cpu_ticks_total) + (ticks - p->cpu_ticks_in);
80103db2:	a1 00 6d 11 80       	mov    0x80116d00,%eax
80103db7:	2b 83 8c 00 00 00    	sub    0x8c(%ebx),%eax
80103dbd:	01 83 88 00 00 00    	add    %eax,0x88(%ebx)
  if(!holding(&ptable.lock))
80103dc3:	83 ec 0c             	sub    $0xc,%esp
80103dc6:	68 e0 b5 10 80       	push   $0x8010b5e0
80103dcb:	e8 87 12 00 00       	call   80105057 <holding>
80103dd0:	83 c4 10             	add    $0x10,%esp
80103dd3:	85 c0                	test   %eax,%eax
80103dd5:	74 4f                	je     80103e26 <sched+0x84>
  if(mycpu()->ncli != 1)
80103dd7:	e8 2d fa ff ff       	call   80103809 <mycpu>
80103ddc:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103de3:	75 4e                	jne    80103e33 <sched+0x91>
  if(p->state == RUNNING)
80103de5:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103de9:	74 55                	je     80103e40 <sched+0x9e>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103deb:	9c                   	pushf  
80103dec:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ded:	f6 c4 02             	test   $0x2,%ah
80103df0:	75 5b                	jne    80103e4d <sched+0xab>
  intena = mycpu()->intena;
80103df2:	e8 12 fa ff ff       	call   80103809 <mycpu>
80103df7:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103dfd:	e8 07 fa ff ff       	call   80103809 <mycpu>
80103e02:	83 ec 08             	sub    $0x8,%esp
80103e05:	ff 70 04             	pushl  0x4(%eax)
80103e08:	83 c3 1c             	add    $0x1c,%ebx
80103e0b:	53                   	push   %ebx
80103e0c:	e8 1b 15 00 00       	call   8010532c <swtch>
  mycpu()->intena = intena;
80103e11:	e8 f3 f9 ff ff       	call   80103809 <mycpu>
80103e16:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e1c:	83 c4 10             	add    $0x10,%esp
80103e1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e22:	5b                   	pop    %ebx
80103e23:	5e                   	pop    %esi
80103e24:	5d                   	pop    %ebp
80103e25:	c3                   	ret    
    panic("sched ptable.lock");
80103e26:	83 ec 0c             	sub    $0xc,%esp
80103e29:	68 88 87 10 80       	push   $0x80108788
80103e2e:	e8 29 c5 ff ff       	call   8010035c <panic>
    panic("sched locks");
80103e33:	83 ec 0c             	sub    $0xc,%esp
80103e36:	68 9a 87 10 80       	push   $0x8010879a
80103e3b:	e8 1c c5 ff ff       	call   8010035c <panic>
    panic("sched running");
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	68 a6 87 10 80       	push   $0x801087a6
80103e48:	e8 0f c5 ff ff       	call   8010035c <panic>
    panic("sched interruptible");
80103e4d:	83 ec 0c             	sub    $0xc,%esp
80103e50:	68 b4 87 10 80       	push   $0x801087b4
80103e55:	e8 02 c5 ff ff       	call   8010035c <panic>

80103e5a <exit>:
{
80103e5a:	f3 0f 1e fb          	endbr32 
80103e5e:	55                   	push   %ebp
80103e5f:	89 e5                	mov    %esp,%ebp
80103e61:	56                   	push   %esi
80103e62:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103e63:	e8 20 fa ff ff       	call   80103888 <myproc>
  if(curproc == initproc)
80103e68:	39 05 c0 b5 10 80    	cmp    %eax,0x8010b5c0
80103e6e:	74 09                	je     80103e79 <exit+0x1f>
80103e70:	89 c3                	mov    %eax,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103e72:	be 00 00 00 00       	mov    $0x0,%esi
80103e77:	eb 10                	jmp    80103e89 <exit+0x2f>
    panic("init exiting");
80103e79:	83 ec 0c             	sub    $0xc,%esp
80103e7c:	68 c8 87 10 80       	push   $0x801087c8
80103e81:	e8 d6 c4 ff ff       	call   8010035c <panic>
  for(fd = 0; fd < NOFILE; fd++){
80103e86:	83 c6 01             	add    $0x1,%esi
80103e89:	83 fe 0f             	cmp    $0xf,%esi
80103e8c:	7f 1e                	jg     80103eac <exit+0x52>
    if(curproc->ofile[fd]){
80103e8e:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e92:	85 c0                	test   %eax,%eax
80103e94:	74 f0                	je     80103e86 <exit+0x2c>
      fileclose(curproc->ofile[fd]);
80103e96:	83 ec 0c             	sub    $0xc,%esp
80103e99:	50                   	push   %eax
80103e9a:	e8 09 cf ff ff       	call   80100da8 <fileclose>
      curproc->ofile[fd] = 0;
80103e9f:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103ea6:	00 
80103ea7:	83 c4 10             	add    $0x10,%esp
80103eaa:	eb da                	jmp    80103e86 <exit+0x2c>
  begin_op();
80103eac:	e8 4f ea ff ff       	call   80102900 <begin_op>
  iput(curproc->cwd);
80103eb1:	83 ec 0c             	sub    $0xc,%esp
80103eb4:	ff 73 68             	pushl  0x68(%ebx)
80103eb7:	e8 ce d8 ff ff       	call   8010178a <iput>
  end_op();
80103ebc:	e8 bd ea ff ff       	call   8010297e <end_op>
  curproc->cwd = 0;
80103ec1:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103ec8:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80103ecf:	e8 c7 11 00 00       	call   8010509b <acquire>
  wakeup1(curproc->parent);
80103ed4:	8b 43 14             	mov    0x14(%ebx),%eax
80103ed7:	e8 d8 f6 ff ff       	call   801035b4 <wakeup1>
  p = ptable.list[EMBRYO].head;
80103edc:	a1 1c dd 10 80       	mov    0x8010dd1c,%eax
  while(p != NULL) {
80103ee1:	83 c4 10             	add    $0x10,%esp
80103ee4:	eb 0f                	jmp    80103ef5 <exit+0x9b>
      p->parent = initproc;
80103ee6:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80103eec:	89 50 14             	mov    %edx,0x14(%eax)
    p = p->next;
80103eef:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  while(p != NULL) {
80103ef5:	85 c0                	test   %eax,%eax
80103ef7:	74 07                	je     80103f00 <exit+0xa6>
    if(p->parent == curproc){
80103ef9:	39 58 14             	cmp    %ebx,0x14(%eax)
80103efc:	75 f1                	jne    80103eef <exit+0x95>
80103efe:	eb e6                	jmp    80103ee6 <exit+0x8c>
  p = ptable.list[SLEEPING].head;
80103f00:	a1 24 dd 10 80       	mov    0x8010dd24,%eax
  while(p != NULL) {
80103f05:	eb 0f                	jmp    80103f16 <exit+0xbc>
      p->parent = initproc;
80103f07:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80103f0d:	89 50 14             	mov    %edx,0x14(%eax)
    p = p->next;
80103f10:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  while(p != NULL) {
80103f16:	85 c0                	test   %eax,%eax
80103f18:	74 07                	je     80103f21 <exit+0xc7>
    if(p->parent == curproc){
80103f1a:	39 58 14             	cmp    %ebx,0x14(%eax)
80103f1d:	75 f1                	jne    80103f10 <exit+0xb6>
80103f1f:	eb e6                	jmp    80103f07 <exit+0xad>
  for(int i = MAXPRIO; i >= 0 ; --i) {
80103f21:	b9 06 00 00 00       	mov    $0x6,%ecx
80103f26:	eb 1d                	jmp    80103f45 <exit+0xeb>
        p->parent = initproc;
80103f28:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80103f2e:	89 50 14             	mov    %edx,0x14(%eax)
      p = p->next;
80103f31:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
    while(p) {
80103f37:	85 c0                	test   %eax,%eax
80103f39:	74 07                	je     80103f42 <exit+0xe8>
      if(p->parent == curproc)
80103f3b:	39 58 14             	cmp    %ebx,0x14(%eax)
80103f3e:	75 f1                	jne    80103f31 <exit+0xd7>
80103f40:	eb e6                	jmp    80103f28 <exit+0xce>
  for(int i = MAXPRIO; i >= 0 ; --i) {
80103f42:	83 e9 01             	sub    $0x1,%ecx
80103f45:	85 c9                	test   %ecx,%ecx
80103f47:	78 09                	js     80103f52 <exit+0xf8>
    p = ptable.ready[i].head;
80103f49:	8b 04 cd 44 dd 10 80 	mov    -0x7fef22bc(,%ecx,8),%eax
    while(p) {
80103f50:	eb e5                	jmp    80103f37 <exit+0xdd>
  p = ptable.list[RUNNING].head;
80103f52:	a1 34 dd 10 80       	mov    0x8010dd34,%eax
  while(p != NULL) {
80103f57:	eb 0f                	jmp    80103f68 <exit+0x10e>
      p->parent = initproc;
80103f59:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80103f5f:	89 50 14             	mov    %edx,0x14(%eax)
    p = p->next;
80103f62:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  while(p != NULL) {
80103f68:	85 c0                	test   %eax,%eax
80103f6a:	74 07                	je     80103f73 <exit+0x119>
    if(p->parent == curproc){
80103f6c:	39 58 14             	cmp    %ebx,0x14(%eax)
80103f6f:	75 f1                	jne    80103f62 <exit+0x108>
80103f71:	eb e6                	jmp    80103f59 <exit+0xff>
  p = ptable.list[ZOMBIE].head;
80103f73:	8b 35 3c dd 10 80    	mov    0x8010dd3c,%esi
  while(p != NULL) {
80103f79:	eb 06                	jmp    80103f81 <exit+0x127>
    p = p->next;
80103f7b:	8b b6 90 00 00 00    	mov    0x90(%esi),%esi
  while(p != NULL) {
80103f81:	85 f6                	test   %esi,%esi
80103f83:	74 14                	je     80103f99 <exit+0x13f>
    if(p->parent == curproc){
80103f85:	39 5e 14             	cmp    %ebx,0x14(%esi)
80103f88:	75 f1                	jne    80103f7b <exit+0x121>
      p->parent = initproc;
80103f8a:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80103f8f:	89 46 14             	mov    %eax,0x14(%esi)
      wakeup1(initproc);
80103f92:	e8 1d f6 ff ff       	call   801035b4 <wakeup1>
80103f97:	eb e2                	jmp    80103f7b <exit+0x121>
  if(stateListRemove(&ptable.list[RUNNING], curproc) == -1) {
80103f99:	89 da                	mov    %ebx,%edx
80103f9b:	b8 34 dd 10 80       	mov    $0x8010dd34,%eax
80103fa0:	e8 3d f2 ff ff       	call   801031e2 <stateListRemove>
80103fa5:	83 f8 ff             	cmp    $0xffffffff,%eax
80103fa8:	74 43                	je     80103fed <exit+0x193>
  assertState(curproc, RUNNING, __FUNCTION__, __LINE__);
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	68 c8 01 00 00       	push   $0x1c8
80103fb2:	b9 14 89 10 80       	mov    $0x80108914,%ecx
80103fb7:	ba 04 00 00 00       	mov    $0x4,%edx
80103fbc:	89 d8                	mov    %ebx,%eax
80103fbe:	e8 26 f4 ff ff       	call   801033e9 <assertState>
  curproc->state = ZOMBIE;
80103fc3:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  stateListAdd(&ptable.list[ZOMBIE], curproc);
80103fca:	89 da                	mov    %ebx,%edx
80103fcc:	b8 3c dd 10 80       	mov    $0x8010dd3c,%eax
80103fd1:	e8 d7 f1 ff ff       	call   801031ad <stateListAdd>
  curproc->sz = 0;
80103fd6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  sched();
80103fdc:	e8 c1 fd ff ff       	call   80103da2 <sched>
  panic("zombie exit");
80103fe1:	c7 04 24 d5 87 10 80 	movl   $0x801087d5,(%esp)
80103fe8:	e8 6f c3 ff ff       	call   8010035c <panic>
    panic("failed to remove from RUNNING in exit()");
80103fed:	83 ec 0c             	sub    $0xc,%esp
80103ff0:	68 a8 84 10 80       	push   $0x801084a8
80103ff5:	e8 62 c3 ff ff       	call   8010035c <panic>

80103ffa <yield>:
{
80103ffa:	f3 0f 1e fb          	endbr32 
80103ffe:	55                   	push   %ebp
80103fff:	89 e5                	mov    %esp,%ebp
80104001:	53                   	push   %ebx
80104002:	83 ec 04             	sub    $0x4,%esp
  struct proc *curproc = myproc();
80104005:	e8 7e f8 ff ff       	call   80103888 <myproc>
8010400a:	89 c3                	mov    %eax,%ebx
  acquire(&ptable.lock);  
8010400c:	83 ec 0c             	sub    $0xc,%esp
8010400f:	68 e0 b5 10 80       	push   $0x8010b5e0
80104014:	e8 82 10 00 00       	call   8010509b <acquire>
  curproc->budget -= (ticks - curproc->cpu_ticks_in);
80104019:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010401f:	2b 05 00 6d 11 80    	sub    0x80116d00,%eax
80104025:	03 83 98 00 00 00    	add    0x98(%ebx),%eax
8010402b:	89 83 98 00 00 00    	mov    %eax,0x98(%ebx)
  if(curproc->budget <= 0 && curproc->priority >= 0) {
80104031:	83 c4 10             	add    $0x10,%esp
80104034:	85 c0                	test   %eax,%eax
80104036:	7e 7a                	jle    801040b2 <yield+0xb8>
  release(&ptable.lock);
80104038:	83 ec 0c             	sub    $0xc,%esp
8010403b:	68 e0 b5 10 80       	push   $0x8010b5e0
80104040:	e8 bf 10 00 00       	call   80105104 <release>
  acquire(&ptable.lock); 
80104045:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010404c:	e8 4a 10 00 00       	call   8010509b <acquire>
  if(stateListRemove(&ptable.list[RUNNING], curproc) == -1) {
80104051:	89 da                	mov    %ebx,%edx
80104053:	b8 34 dd 10 80       	mov    $0x8010dd34,%eax
80104058:	e8 85 f1 ff ff       	call   801031e2 <stateListRemove>
8010405d:	83 c4 10             	add    $0x10,%esp
80104060:	83 f8 ff             	cmp    $0xffffffff,%eax
80104063:	74 6f                	je     801040d4 <yield+0xda>
  assertState(curproc, RUNNING, __FUNCTION__, __LINE__);
80104065:	83 ec 0c             	sub    $0xc,%esp
80104068:	68 47 03 00 00       	push   $0x347
8010406d:	b9 f0 88 10 80       	mov    $0x801088f0,%ecx
80104072:	ba 04 00 00 00       	mov    $0x4,%edx
80104077:	89 d8                	mov    %ebx,%eax
80104079:	e8 6b f3 ff ff       	call   801033e9 <assertState>
  curproc->state = RUNNABLE;
8010407e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  stateListAdd(&ptable.ready[curproc->priority], curproc);
80104085:	8b 83 94 00 00 00    	mov    0x94(%ebx),%eax
8010408b:	8d 04 c5 44 dd 10 80 	lea    -0x7fef22bc(,%eax,8),%eax
80104092:	89 da                	mov    %ebx,%edx
80104094:	e8 14 f1 ff ff       	call   801031ad <stateListAdd>
  sched();
80104099:	e8 04 fd ff ff       	call   80103da2 <sched>
  release(&ptable.lock);
8010409e:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801040a5:	e8 5a 10 00 00       	call   80105104 <release>
}
801040aa:	83 c4 10             	add    $0x10,%esp
801040ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040b0:	c9                   	leave  
801040b1:	c3                   	ret    
    if(curproc->priority > 0)
801040b2:	8b 83 94 00 00 00    	mov    0x94(%ebx),%eax
801040b8:	85 c0                	test   %eax,%eax
801040ba:	74 09                	je     801040c5 <yield+0xcb>
      --curproc->priority;
801040bc:	83 e8 01             	sub    $0x1,%eax
801040bf:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
    curproc->budget = BUDGET;
801040c5:	c7 83 98 00 00 00 2c 	movl   $0x12c,0x98(%ebx)
801040cc:	01 00 00 
801040cf:	e9 64 ff ff ff       	jmp    80104038 <yield+0x3e>
    panic("failed to remove from RUNNING list in yield()");
801040d4:	83 ec 0c             	sub    $0xc,%esp
801040d7:	68 d0 84 10 80       	push   $0x801084d0
801040dc:	e8 7b c2 ff ff       	call   8010035c <panic>

801040e1 <sleep>:
{
801040e1:	f3 0f 1e fb          	endbr32 
801040e5:	55                   	push   %ebp
801040e6:	89 e5                	mov    %esp,%ebp
801040e8:	56                   	push   %esi
801040e9:	53                   	push   %ebx
801040ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
801040ed:	e8 96 f7 ff ff       	call   80103888 <myproc>
  if(p == 0)
801040f2:	85 c0                	test   %eax,%eax
801040f4:	0f 84 cf 00 00 00    	je     801041c9 <sleep+0xe8>
801040fa:	89 c3                	mov    %eax,%ebx
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040fc:	81 fe e0 b5 10 80    	cmp    $0x8010b5e0,%esi
80104102:	74 20                	je     80104124 <sleep+0x43>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104104:	83 ec 0c             	sub    $0xc,%esp
80104107:	68 e0 b5 10 80       	push   $0x8010b5e0
8010410c:	e8 8a 0f 00 00       	call   8010509b <acquire>
    if (lk) release(lk);
80104111:	83 c4 10             	add    $0x10,%esp
80104114:	85 f6                	test   %esi,%esi
80104116:	74 0c                	je     80104124 <sleep+0x43>
80104118:	83 ec 0c             	sub    $0xc,%esp
8010411b:	56                   	push   %esi
8010411c:	e8 e3 0f 00 00       	call   80105104 <release>
80104121:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80104124:	8b 45 08             	mov    0x8(%ebp),%eax
80104127:	89 43 20             	mov    %eax,0x20(%ebx)
  p->budget -= (ticks - p->cpu_ticks_in);
8010412a:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80104130:	2b 05 00 6d 11 80    	sub    0x80116d00,%eax
80104136:	03 83 98 00 00 00    	add    0x98(%ebx),%eax
8010413c:	89 83 98 00 00 00    	mov    %eax,0x98(%ebx)
  if(p->budget <= 0 && p->priority >= 0) {
80104142:	85 c0                	test   %eax,%eax
80104144:	0f 8e 8c 00 00 00    	jle    801041d6 <sleep+0xf5>
  if(stateListRemove(&ptable.list[RUNNING], p) == -1) {
8010414a:	89 da                	mov    %ebx,%edx
8010414c:	b8 34 dd 10 80       	mov    $0x8010dd34,%eax
80104151:	e8 8c f0 ff ff       	call   801031e2 <stateListRemove>
80104156:	83 f8 ff             	cmp    $0xffffffff,%eax
80104159:	0f 84 99 00 00 00    	je     801041f8 <sleep+0x117>
  assertState(p, RUNNING, __FUNCTION__, __LINE__);
8010415f:	83 ec 0c             	sub    $0xc,%esp
80104162:	68 95 03 00 00       	push   $0x395
80104167:	b9 e8 88 10 80       	mov    $0x801088e8,%ecx
8010416c:	ba 04 00 00 00       	mov    $0x4,%edx
80104171:	89 d8                	mov    %ebx,%eax
80104173:	e8 71 f2 ff ff       	call   801033e9 <assertState>
  p->state = SLEEPING;
80104178:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  stateListAdd(&ptable.list[SLEEPING], p);
8010417f:	89 da                	mov    %ebx,%edx
80104181:	b8 24 dd 10 80       	mov    $0x8010dd24,%eax
80104186:	e8 22 f0 ff ff       	call   801031ad <stateListAdd>
  sched();
8010418b:	e8 12 fc ff ff       	call   80103da2 <sched>
  p->chan = 0;
80104190:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  
80104197:	83 c4 10             	add    $0x10,%esp
8010419a:	81 fe e0 b5 10 80    	cmp    $0x8010b5e0,%esi
801041a0:	74 20                	je     801041c2 <sleep+0xe1>
    release(&ptable.lock);
801041a2:	83 ec 0c             	sub    $0xc,%esp
801041a5:	68 e0 b5 10 80       	push   $0x8010b5e0
801041aa:	e8 55 0f 00 00       	call   80105104 <release>
    if (lk) acquire(lk);
801041af:	83 c4 10             	add    $0x10,%esp
801041b2:	85 f6                	test   %esi,%esi
801041b4:	74 0c                	je     801041c2 <sleep+0xe1>
801041b6:	83 ec 0c             	sub    $0xc,%esp
801041b9:	56                   	push   %esi
801041ba:	e8 dc 0e 00 00       	call   8010509b <acquire>
801041bf:	83 c4 10             	add    $0x10,%esp
}
801041c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c5:	5b                   	pop    %ebx
801041c6:	5e                   	pop    %esi
801041c7:	5d                   	pop    %ebp
801041c8:	c3                   	ret    
    panic("sleep");
801041c9:	83 ec 0c             	sub    $0xc,%esp
801041cc:	68 e1 87 10 80       	push   $0x801087e1
801041d1:	e8 86 c1 ff ff       	call   8010035c <panic>
    if(p->priority > 0)
801041d6:	8b 83 94 00 00 00    	mov    0x94(%ebx),%eax
801041dc:	85 c0                	test   %eax,%eax
801041de:	74 09                	je     801041e9 <sleep+0x108>
      --p->priority;
801041e0:	83 e8 01             	sub    $0x1,%eax
801041e3:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
    p->budget = BUDGET;
801041e9:	c7 83 98 00 00 00 2c 	movl   $0x12c,0x98(%ebx)
801041f0:	01 00 00 
801041f3:	e9 52 ff ff ff       	jmp    8010414a <sleep+0x69>
    panic("failed to remove from RUNNING in sleep()");
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 00 85 10 80       	push   $0x80108500
80104200:	e8 57 c1 ff ff       	call   8010035c <panic>

80104205 <wait>:
{
80104205:	f3 0f 1e fb          	endbr32 
80104209:	55                   	push   %ebp
8010420a:	89 e5                	mov    %esp,%ebp
8010420c:	57                   	push   %edi
8010420d:	56                   	push   %esi
8010420e:	53                   	push   %ebx
8010420f:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104212:	e8 71 f6 ff ff       	call   80103888 <myproc>
80104217:	89 c3                	mov    %eax,%ebx
  acquire(&ptable.lock);
80104219:	83 ec 0c             	sub    $0xc,%esp
8010421c:	68 e0 b5 10 80       	push   $0x8010b5e0
80104221:	e8 75 0e 00 00       	call   8010509b <acquire>
80104226:	83 c4 10             	add    $0x10,%esp
    p = ptable.list[ZOMBIE].head;
80104229:	8b 35 3c dd 10 80    	mov    0x8010dd3c,%esi
    while(p != NULL && !havekids){
8010422f:	85 f6                	test   %esi,%esi
80104231:	0f 84 c4 00 00 00    	je     801042fb <wait+0xf6>
      if(p->parent == curproc){
80104237:	39 5e 14             	cmp    %ebx,0x14(%esi)
8010423a:	74 08                	je     80104244 <wait+0x3f>
        p = p->next; 
8010423c:	8b b6 90 00 00 00    	mov    0x90(%esi),%esi
80104242:	eb eb                	jmp    8010422f <wait+0x2a>
        pid = p->pid;
80104244:	8b 5e 10             	mov    0x10(%esi),%ebx
        kfree(p->kstack);
80104247:	83 ec 0c             	sub    $0xc,%esp
8010424a:	ff 76 08             	pushl  0x8(%esi)
8010424d:	e8 8a de ff ff       	call   801020dc <kfree>
        p->kstack = 0;
80104252:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
        freevm(p->pgdir); 
80104259:	83 c4 04             	add    $0x4,%esp
8010425c:	ff 76 04             	pushl  0x4(%esi)
8010425f:	e8 4b 36 00 00       	call   801078af <freevm>
        if(stateListRemove(&ptable.list[ZOMBIE], p) == -1) {
80104264:	89 f2                	mov    %esi,%edx
80104266:	b8 3c dd 10 80       	mov    $0x8010dd3c,%eax
8010426b:	e8 72 ef ff ff       	call   801031e2 <stateListRemove>
80104270:	83 c4 10             	add    $0x10,%esp
80104273:	83 f8 ff             	cmp    $0xffffffff,%eax
80104276:	74 76                	je     801042ee <wait+0xe9>
        assertState(p, ZOMBIE, __FUNCTION__, __LINE__);
80104278:	83 ec 0c             	sub    $0xc,%esp
8010427b:	68 21 02 00 00       	push   $0x221
80104280:	b9 04 89 10 80       	mov    $0x80108904,%ecx
80104285:	ba 05 00 00 00       	mov    $0x5,%edx
8010428a:	89 f0                	mov    %esi,%eax
8010428c:	e8 58 f1 ff ff       	call   801033e9 <assertState>
        p->state = UNUSED;
80104291:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
        stateListAdd(&ptable.list[UNUSED], p);
80104298:	89 f2                	mov    %esi,%edx
8010429a:	b8 14 dd 10 80       	mov    $0x8010dd14,%eax
8010429f:	e8 09 ef ff ff       	call   801031ad <stateListAdd>
        assertState(p, UNUSED, __FUNCTION__, __LINE__);
801042a4:	c7 04 24 24 02 00 00 	movl   $0x224,(%esp)
801042ab:	b9 04 89 10 80       	mov    $0x80108904,%ecx
801042b0:	ba 00 00 00 00       	mov    $0x0,%edx
801042b5:	89 f0                	mov    %esi,%eax
801042b7:	e8 2d f1 ff ff       	call   801033e9 <assertState>
        p->pid = 0;
801042bc:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
        p->parent = 0;
801042c3:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
        p->name[0] = 0;
801042ca:	c6 46 6c 00          	movb   $0x0,0x6c(%esi)
        p->killed = 0;
801042ce:	c7 46 24 00 00 00 00 	movl   $0x0,0x24(%esi)
        release(&ptable.lock);
801042d5:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801042dc:	e8 23 0e 00 00       	call   80105104 <release>
        return pid;
801042e1:	89 d8                	mov    %ebx,%eax
801042e3:	83 c4 10             	add    $0x10,%esp
}
801042e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e9:	5b                   	pop    %ebx
801042ea:	5e                   	pop    %esi
801042eb:	5f                   	pop    %edi
801042ec:	5d                   	pop    %ebp
801042ed:	c3                   	ret    
          panic("failure to remove ZOMBIE in wait()");
801042ee:	83 ec 0c             	sub    $0xc,%esp
801042f1:	68 2c 85 10 80       	push   $0x8010852c
801042f6:	e8 61 c0 ff ff       	call   8010035c <panic>
    p = ptable.list[EMBRYO].head;
801042fb:	a1 1c dd 10 80       	mov    0x8010dd1c,%eax
    havekids = 0;
80104300:	bf 00 00 00 00       	mov    $0x0,%edi
    while(p != NULL && !havekids){
80104305:	eb 06                	jmp    8010430d <wait+0x108>
      p = p->next;
80104307:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
    while(p != NULL && !havekids){
8010430d:	85 c0                	test   %eax,%eax
8010430f:	0f 95 c1             	setne  %cl
80104312:	89 ce                	mov    %ecx,%esi
80104314:	85 ff                	test   %edi,%edi
80104316:	0f 94 c1             	sete   %cl
80104319:	89 f2                	mov    %esi,%edx
8010431b:	84 ca                	test   %cl,%dl
8010431d:	74 0c                	je     8010432b <wait+0x126>
      if(p->parent == curproc){
8010431f:	39 58 14             	cmp    %ebx,0x14(%eax)
80104322:	75 e3                	jne    80104307 <wait+0x102>
        havekids = 1;
80104324:	bf 01 00 00 00       	mov    $0x1,%edi
80104329:	eb dc                	jmp    80104307 <wait+0x102>
    p = ptable.list[SLEEPING].head;
8010432b:	a1 24 dd 10 80       	mov    0x8010dd24,%eax
    while(p != NULL && !havekids){
80104330:	eb 06                	jmp    80104338 <wait+0x133>
      p = p->next;
80104332:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
    while(p != NULL && !havekids){
80104338:	85 c0                	test   %eax,%eax
8010433a:	0f 95 c2             	setne  %dl
8010433d:	85 ff                	test   %edi,%edi
8010433f:	0f 94 c1             	sete   %cl
80104342:	84 ca                	test   %cl,%dl
80104344:	74 0c                	je     80104352 <wait+0x14d>
      if(p->parent == curproc){
80104346:	39 58 14             	cmp    %ebx,0x14(%eax)
80104349:	75 e7                	jne    80104332 <wait+0x12d>
        havekids = 1;
8010434b:	bf 01 00 00 00       	mov    $0x1,%edi
80104350:	eb e0                	jmp    80104332 <wait+0x12d>
    for(int i = MAXPRIO; i >= 0 ; --i) {
80104352:	b9 06 00 00 00       	mov    $0x6,%ecx
80104357:	eb 19                	jmp    80104372 <wait+0x16d>
        p = p->next;
80104359:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
      while(p) {
8010435f:	85 c0                	test   %eax,%eax
80104361:	74 0c                	je     8010436f <wait+0x16a>
        if(p->parent == curproc) {
80104363:	39 58 14             	cmp    %ebx,0x14(%eax)
80104366:	75 f1                	jne    80104359 <wait+0x154>
          havekids = 1;
80104368:	bf 01 00 00 00       	mov    $0x1,%edi
8010436d:	eb ea                	jmp    80104359 <wait+0x154>
    for(int i = MAXPRIO; i >= 0 ; --i) {
8010436f:	83 e9 01             	sub    $0x1,%ecx
80104372:	85 c9                	test   %ecx,%ecx
80104374:	78 09                	js     8010437f <wait+0x17a>
      p = ptable.ready[i].head;
80104376:	8b 04 cd 44 dd 10 80 	mov    -0x7fef22bc(,%ecx,8),%eax
      while(p) {
8010437d:	eb e0                	jmp    8010435f <wait+0x15a>
    p = ptable.list[RUNNING].head;
8010437f:	a1 34 dd 10 80       	mov    0x8010dd34,%eax
    while(p != NULL && !havekids){
80104384:	eb 06                	jmp    8010438c <wait+0x187>
      p = p->next;
80104386:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
    while(p != NULL && !havekids){
8010438c:	85 c0                	test   %eax,%eax
8010438e:	0f 95 c2             	setne  %dl
80104391:	85 ff                	test   %edi,%edi
80104393:	0f 94 c1             	sete   %cl
80104396:	84 ca                	test   %cl,%dl
80104398:	74 0c                	je     801043a6 <wait+0x1a1>
      if(p->parent == curproc){
8010439a:	39 58 14             	cmp    %ebx,0x14(%eax)
8010439d:	75 e7                	jne    80104386 <wait+0x181>
        havekids = 1;
8010439f:	bf 01 00 00 00       	mov    $0x1,%edi
801043a4:	eb e0                	jmp    80104386 <wait+0x181>
    if(!havekids || curproc->killed){
801043a6:	85 ff                	test   %edi,%edi
801043a8:	74 1c                	je     801043c6 <wait+0x1c1>
801043aa:	83 7b 24 00          	cmpl   $0x0,0x24(%ebx)
801043ae:	75 16                	jne    801043c6 <wait+0x1c1>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801043b0:	83 ec 08             	sub    $0x8,%esp
801043b3:	68 e0 b5 10 80       	push   $0x8010b5e0
801043b8:	53                   	push   %ebx
801043b9:	e8 23 fd ff ff       	call   801040e1 <sleep>
    havekids = 0;
801043be:	83 c4 10             	add    $0x10,%esp
801043c1:	e9 63 fe ff ff       	jmp    80104229 <wait+0x24>
      release(&ptable.lock);
801043c6:	83 ec 0c             	sub    $0xc,%esp
801043c9:	68 e0 b5 10 80       	push   $0x8010b5e0
801043ce:	e8 31 0d 00 00       	call   80105104 <release>
      return -1;
801043d3:	83 c4 10             	add    $0x10,%esp
801043d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043db:	e9 06 ff ff ff       	jmp    801042e6 <wait+0xe1>

801043e0 <wakeup>:
{
801043e0:	f3 0f 1e fb          	endbr32 
801043e4:	55                   	push   %ebp
801043e5:	89 e5                	mov    %esp,%ebp
801043e7:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801043ea:	68 e0 b5 10 80       	push   $0x8010b5e0
801043ef:	e8 a7 0c 00 00       	call   8010509b <acquire>
  wakeup1(chan);
801043f4:	8b 45 08             	mov    0x8(%ebp),%eax
801043f7:	e8 b8 f1 ff ff       	call   801035b4 <wakeup1>
  release(&ptable.lock);
801043fc:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80104403:	e8 fc 0c 00 00       	call   80105104 <release>
}
80104408:	83 c4 10             	add    $0x10,%esp
8010440b:	c9                   	leave  
8010440c:	c3                   	ret    

8010440d <kill>:
{
8010440d:	f3 0f 1e fb          	endbr32 
80104411:	55                   	push   %ebp
80104412:	89 e5                	mov    %esp,%ebp
80104414:	56                   	push   %esi
80104415:	53                   	push   %ebx
80104416:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&ptable.lock);
80104419:	83 ec 0c             	sub    $0xc,%esp
8010441c:	68 e0 b5 10 80       	push   $0x8010b5e0
80104421:	e8 75 0c 00 00       	call   8010509b <acquire>
  temp = ptable.list[SLEEPING].head;
80104426:	8b 1d 24 dd 10 80    	mov    0x8010dd24,%ebx
  while(temp != NULL){ 
8010442c:	83 c4 10             	add    $0x10,%esp
8010442f:	85 db                	test   %ebx,%ebx
80104431:	0f 84 8b 00 00 00    	je     801044c2 <kill+0xb5>
    if(temp->pid == pid){
80104437:	39 73 10             	cmp    %esi,0x10(%ebx)
8010443a:	74 08                	je     80104444 <kill+0x37>
      temp = temp->next;
8010443c:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
80104442:	eb eb                	jmp    8010442f <kill+0x22>
      temp->killed = 1;
80104444:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      if(temp->state == SLEEPING) {
8010444b:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
8010444f:	75 48                	jne    80104499 <kill+0x8c>
        if(stateListRemove(&ptable.list[SLEEPING], p) == -1) {
80104451:	89 da                	mov    %ebx,%edx
80104453:	b8 24 dd 10 80       	mov    $0x8010dd24,%eax
80104458:	e8 85 ed ff ff       	call   801031e2 <stateListRemove>
8010445d:	83 f8 ff             	cmp    $0xffffffff,%eax
80104460:	74 53                	je     801044b5 <kill+0xa8>
        assertState(p, SLEEPING, __FUNCTION__, __LINE__);
80104462:	83 ec 0c             	sub    $0xc,%esp
80104465:	68 12 04 00 00       	push   $0x412
8010446a:	b9 e0 88 10 80       	mov    $0x801088e0,%ecx
8010446f:	ba 02 00 00 00       	mov    $0x2,%edx
80104474:	89 d8                	mov    %ebx,%eax
80104476:	e8 6e ef ff ff       	call   801033e9 <assertState>
        p->state = RUNNABLE;
8010447b:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
        stateListAdd(&ptable.ready[p->priority], p);  //TODO ALTERED
80104482:	8b 83 94 00 00 00    	mov    0x94(%ebx),%eax
80104488:	8d 04 c5 44 dd 10 80 	lea    -0x7fef22bc(,%eax,8),%eax
8010448f:	89 da                	mov    %ebx,%edx
80104491:	e8 17 ed ff ff       	call   801031ad <stateListAdd>
80104496:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
80104499:	83 ec 0c             	sub    $0xc,%esp
8010449c:	68 e0 b5 10 80       	push   $0x8010b5e0
801044a1:	e8 5e 0c 00 00       	call   80105104 <release>
      return 0;  
801044a6:	83 c4 10             	add    $0x10,%esp
801044a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044b1:	5b                   	pop    %ebx
801044b2:	5e                   	pop    %esi
801044b3:	5d                   	pop    %ebp
801044b4:	c3                   	ret    
          panic("failed to remove process from SLEEPING list in kill()");
801044b5:	83 ec 0c             	sub    $0xc,%esp
801044b8:	68 50 85 10 80       	push   $0x80108550
801044bd:	e8 9a be ff ff       	call   8010035c <panic>
  p = ptable.list[EMBRYO].head;
801044c2:	a1 1c dd 10 80       	mov    0x8010dd1c,%eax
  while(p != NULL) {
801044c7:	85 c0                	test   %eax,%eax
801044c9:	74 2b                	je     801044f6 <kill+0xe9>
    if(p->pid == pid){
801044cb:	39 70 10             	cmp    %esi,0x10(%eax)
801044ce:	74 08                	je     801044d8 <kill+0xcb>
    p = p->next;
801044d0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801044d6:	eb ef                	jmp    801044c7 <kill+0xba>
      p->killed = 1;
801044d8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
801044df:	83 ec 0c             	sub    $0xc,%esp
801044e2:	68 e0 b5 10 80       	push   $0x8010b5e0
801044e7:	e8 18 0c 00 00       	call   80105104 <release>
      return 0;
801044ec:	83 c4 10             	add    $0x10,%esp
801044ef:	b8 00 00 00 00       	mov    $0x0,%eax
801044f4:	eb b8                	jmp    801044ae <kill+0xa1>
  for(int i = MAXPRIO; i >= 0 ; --i) {
801044f6:	ba 06 00 00 00       	mov    $0x6,%edx
801044fb:	85 d2                	test   %edx,%edx
801044fd:	78 3e                	js     8010453d <kill+0x130>
    p = ptable.ready[i].head;
801044ff:	8b 04 d5 44 dd 10 80 	mov    -0x7fef22bc(,%edx,8),%eax
    while(p != NULL) {
80104506:	85 c0                	test   %eax,%eax
80104508:	74 2e                	je     80104538 <kill+0x12b>
      if(p->pid == pid) {
8010450a:	39 70 10             	cmp    %esi,0x10(%eax)
8010450d:	74 08                	je     80104517 <kill+0x10a>
      p = p->next;
8010450f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104515:	eb ef                	jmp    80104506 <kill+0xf9>
        p->killed = 1;
80104517:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        release(&ptable.lock);
8010451e:	83 ec 0c             	sub    $0xc,%esp
80104521:	68 e0 b5 10 80       	push   $0x8010b5e0
80104526:	e8 d9 0b 00 00       	call   80105104 <release>
        return 0;
8010452b:	83 c4 10             	add    $0x10,%esp
8010452e:	b8 00 00 00 00       	mov    $0x0,%eax
80104533:	e9 76 ff ff ff       	jmp    801044ae <kill+0xa1>
  for(int i = MAXPRIO; i >= 0 ; --i) {
80104538:	83 ea 01             	sub    $0x1,%edx
8010453b:	eb be                	jmp    801044fb <kill+0xee>
  p = ptable.list[RUNNING].head;
8010453d:	a1 34 dd 10 80       	mov    0x8010dd34,%eax
  while(p != NULL) {
80104542:	85 c0                	test   %eax,%eax
80104544:	74 2e                	je     80104574 <kill+0x167>
    if(p->pid == pid){
80104546:	39 70 10             	cmp    %esi,0x10(%eax)
80104549:	74 08                	je     80104553 <kill+0x146>
    p = p->next;
8010454b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104551:	eb ef                	jmp    80104542 <kill+0x135>
      p->killed = 1;
80104553:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
8010455a:	83 ec 0c             	sub    $0xc,%esp
8010455d:	68 e0 b5 10 80       	push   $0x8010b5e0
80104562:	e8 9d 0b 00 00       	call   80105104 <release>
      return 0;
80104567:	83 c4 10             	add    $0x10,%esp
8010456a:	b8 00 00 00 00       	mov    $0x0,%eax
8010456f:	e9 3a ff ff ff       	jmp    801044ae <kill+0xa1>
  p = ptable.list[ZOMBIE].head;
80104574:	a1 3c dd 10 80       	mov    0x8010dd3c,%eax
  while(p != NULL) {
80104579:	85 c0                	test   %eax,%eax
8010457b:	74 2e                	je     801045ab <kill+0x19e>
    if(p->pid == pid){
8010457d:	39 70 10             	cmp    %esi,0x10(%eax)
80104580:	74 08                	je     8010458a <kill+0x17d>
    p = p->next;
80104582:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104588:	eb ef                	jmp    80104579 <kill+0x16c>
      p->killed = 1;
8010458a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
80104591:	83 ec 0c             	sub    $0xc,%esp
80104594:	68 e0 b5 10 80       	push   $0x8010b5e0
80104599:	e8 66 0b 00 00       	call   80105104 <release>
      return 0;
8010459e:	83 c4 10             	add    $0x10,%esp
801045a1:	b8 00 00 00 00       	mov    $0x0,%eax
801045a6:	e9 03 ff ff ff       	jmp    801044ae <kill+0xa1>
  release(&ptable.lock);
801045ab:	83 ec 0c             	sub    $0xc,%esp
801045ae:	68 e0 b5 10 80       	push   $0x8010b5e0
801045b3:	e8 4c 0b 00 00       	call   80105104 <release>
  return -1;
801045b8:	83 c4 10             	add    $0x10,%esp
801045bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045c0:	e9 e9 fe ff ff       	jmp    801044ae <kill+0xa1>

801045c5 <procdumpP2P3P4>:
{
801045c5:	f3 0f 1e fb          	endbr32 
801045c9:	55                   	push   %ebp
801045ca:	89 e5                	mov    %esp,%ebp
801045cc:	57                   	push   %edi
801045cd:	56                   	push   %esi
801045ce:	53                   	push   %ebx
801045cf:	83 ec 1c             	sub    $0x1c,%esp
801045d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p->parent != NULL)
801045d5:	8b 43 14             	mov    0x14(%ebx),%eax
801045d8:	85 c0                	test   %eax,%eax
801045da:	74 79                	je     80104655 <procdumpP2P3P4+0x90>
    ppid = p->parent->pid;
801045dc:	8b 48 10             	mov    0x10(%eax),%ecx
  elapsed = ticks - p->start_ticks;
801045df:	8b 3d 00 6d 11 80    	mov    0x80116d00,%edi
801045e5:	2b 7b 7c             	sub    0x7c(%ebx),%edi
  elapsed_dec = elapsed % 1000;
801045e8:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
801045ed:	89 f8                	mov    %edi,%eax
801045ef:	f7 e2                	mul    %edx
801045f1:	89 d6                	mov    %edx,%esi
801045f3:	c1 ee 06             	shr    $0x6,%esi
801045f6:	69 c6 e8 03 00 00    	imul   $0x3e8,%esi,%eax
801045fc:	89 fe                	mov    %edi,%esi
801045fe:	29 c6                	sub    %eax,%esi
  elapsed = elapsed / 1000;
80104600:	c1 ea 06             	shr    $0x6,%edx
80104603:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  CPU_total_ticks = p->cpu_ticks_total;
80104606:	8b bb 88 00 00 00    	mov    0x88(%ebx),%edi
  cprintf("%d\t%s\t     %d\t        %d\t%d\t%d\t", p->pid, p->name, p->uid, p->gid, ppid, p->priority);
8010460c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010460f:	83 ec 04             	sub    $0x4,%esp
80104612:	ff b3 94 00 00 00    	pushl  0x94(%ebx)
80104618:	51                   	push   %ecx
80104619:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
8010461f:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80104625:	50                   	push   %eax
80104626:	ff 73 10             	pushl  0x10(%ebx)
80104629:	68 88 85 10 80       	push   $0x80108588
8010462e:	e8 f6 bf ff ff       	call   80100629 <cprintf>
  cprintf("%d.%d\t0.0%d\t%s\t%d\t", elapsed, elapsed_dec, CPU_total_ticks, state_string, p->sz);
80104633:	83 c4 18             	add    $0x18,%esp
80104636:	ff 33                	pushl  (%ebx)
80104638:	ff 75 0c             	pushl  0xc(%ebp)
8010463b:	57                   	push   %edi
8010463c:	56                   	push   %esi
8010463d:	ff 75 e4             	pushl  -0x1c(%ebp)
80104640:	68 e7 87 10 80       	push   $0x801087e7
80104645:	e8 df bf ff ff       	call   80100629 <cprintf>
  return;
8010464a:	83 c4 20             	add    $0x20,%esp
}
8010464d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104650:	5b                   	pop    %ebx
80104651:	5e                   	pop    %esi
80104652:	5f                   	pop    %edi
80104653:	5d                   	pop    %ebp
80104654:	c3                   	ret    
    ppid = p->pid;
80104655:	8b 4b 10             	mov    0x10(%ebx),%ecx
80104658:	eb 85                	jmp    801045df <procdumpP2P3P4+0x1a>

8010465a <procdump>:
{
8010465a:	f3 0f 1e fb          	endbr32 
8010465e:	55                   	push   %ebp
8010465f:	89 e5                	mov    %esp,%ebp
80104661:	56                   	push   %esi
80104662:	53                   	push   %ebx
80104663:	83 ec 3c             	sub    $0x3c,%esp
  cprintf(HEADER);  // not conditionally compiled as must work in all project states
80104666:	68 a8 85 10 80       	push   $0x801085a8
8010466b:	e8 b9 bf ff ff       	call   80100629 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104670:	83 c4 10             	add    $0x10,%esp
80104673:	bb 14 b6 10 80       	mov    $0x8010b614,%ebx
80104678:	eb 2e                	jmp    801046a8 <procdump+0x4e>
      state = "???";
8010467a:	b8 fa 87 10 80       	mov    $0x801087fa,%eax
    procdumpP2P3P4(p, state);
8010467f:	83 ec 08             	sub    $0x8,%esp
80104682:	50                   	push   %eax
80104683:	53                   	push   %ebx
80104684:	e8 3c ff ff ff       	call   801045c5 <procdumpP2P3P4>
    if(p->state == SLEEPING){
80104689:	83 c4 10             	add    $0x10,%esp
8010468c:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104690:	74 3c                	je     801046ce <procdump+0x74>
    cprintf("\n");
80104692:	83 ec 0c             	sub    $0xc,%esp
80104695:	68 7b 8c 10 80       	push   $0x80108c7b
8010469a:	e8 8a bf ff ff       	call   80100629 <cprintf>
8010469f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a2:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801046a8:	81 fb 14 dd 10 80    	cmp    $0x8010dd14,%ebx
801046ae:	73 61                	jae    80104711 <procdump+0xb7>
    if(p->state == UNUSED)
801046b0:	8b 43 0c             	mov    0xc(%ebx),%eax
801046b3:	85 c0                	test   %eax,%eax
801046b5:	74 eb                	je     801046a2 <procdump+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046b7:	83 f8 05             	cmp    $0x5,%eax
801046ba:	77 be                	ja     8010467a <procdump+0x20>
801046bc:	8b 04 85 3c 89 10 80 	mov    -0x7fef76c4(,%eax,4),%eax
801046c3:	85 c0                	test   %eax,%eax
801046c5:	75 b8                	jne    8010467f <procdump+0x25>
      state = "???";
801046c7:	b8 fa 87 10 80       	mov    $0x801087fa,%eax
801046cc:	eb b1                	jmp    8010467f <procdump+0x25>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046ce:	8b 43 1c             	mov    0x1c(%ebx),%eax
801046d1:	8b 40 0c             	mov    0xc(%eax),%eax
801046d4:	83 c0 08             	add    $0x8,%eax
801046d7:	83 ec 08             	sub    $0x8,%esp
801046da:	8d 55 d0             	lea    -0x30(%ebp),%edx
801046dd:	52                   	push   %edx
801046de:	50                   	push   %eax
801046df:	e8 86 08 00 00       	call   80104f6a <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801046e4:	83 c4 10             	add    $0x10,%esp
801046e7:	be 00 00 00 00       	mov    $0x0,%esi
801046ec:	eb 14                	jmp    80104702 <procdump+0xa8>
        cprintf(" %p", pc[i]);
801046ee:	83 ec 08             	sub    $0x8,%esp
801046f1:	50                   	push   %eax
801046f2:	68 c1 7b 10 80       	push   $0x80107bc1
801046f7:	e8 2d bf ff ff       	call   80100629 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801046fc:	83 c6 01             	add    $0x1,%esi
801046ff:	83 c4 10             	add    $0x10,%esp
80104702:	83 fe 09             	cmp    $0x9,%esi
80104705:	7f 8b                	jg     80104692 <procdump+0x38>
80104707:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
8010470b:	85 c0                	test   %eax,%eax
8010470d:	75 df                	jne    801046ee <procdump+0x94>
8010470f:	eb 81                	jmp    80104692 <procdump+0x38>
  cprintf("$ ");  // simulate shell prompt
80104711:	83 ec 0c             	sub    $0xc,%esp
80104714:	68 7a 88 10 80       	push   $0x8010887a
80104719:	e8 0b bf ff ff       	call   80100629 <cprintf>
}
8010471e:	83 c4 10             	add    $0x10,%esp
80104721:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104724:	5b                   	pop    %ebx
80104725:	5e                   	pop    %esi
80104726:	5d                   	pop    %ebp
80104727:	c3                   	ret    

80104728 <printList>:
{
80104728:	f3 0f 1e fb          	endbr32 
8010472c:	55                   	push   %ebp
8010472d:	89 e5                	mov    %esp,%ebp
8010472f:	57                   	push   %edi
80104730:	56                   	push   %esi
80104731:	53                   	push   %ebx
80104732:	83 ec 1c             	sub    $0x1c,%esp
80104735:	8b 7d 08             	mov    0x8(%ebp),%edi
  if (state < UNUSED || state > ZOMBIE) {
80104738:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010473b:	83 ff 05             	cmp    $0x5,%edi
8010473e:	77 3d                	ja     8010477d <printList+0x55>
  acquire(&ptable.lock);
80104740:	83 ec 0c             	sub    $0xc,%esp
80104743:	68 e0 b5 10 80       	push   $0x8010b5e0
80104748:	e8 4e 09 00 00       	call   8010509b <acquire>
  if (state == RUNNABLE) {
8010474d:	83 c4 10             	add    $0x10,%esp
80104750:	83 ff 03             	cmp    $0x3,%edi
80104753:	74 49                	je     8010479e <printList+0x76>
  cprintf("\n%s List Processes:\n", stateNames[state]);
80104755:	83 ec 08             	sub    $0x8,%esp
80104758:	ff 34 bd c8 88 10 80 	pushl  -0x7fef7738(,%edi,4)
8010475f:	68 18 88 10 80       	push   $0x80108818
80104764:	e8 c0 be ff ff       	call   80100629 <cprintf>
  p = ptable.list[state].head;
80104769:	8b 1c fd 14 dd 10 80 	mov    -0x7fef22ec(,%edi,8),%ebx
  while (p != NULL) {
80104770:	83 c4 10             	add    $0x10,%esp
  int count = 0;
80104773:	be 00 00 00 00       	mov    $0x0,%esi
  while (p != NULL) {
80104778:	e9 bf 00 00 00       	jmp    8010483c <printList+0x114>
    cprintf("Invalid control sequence\n");
8010477d:	83 ec 0c             	sub    $0xc,%esp
80104780:	68 fe 87 10 80       	push   $0x801087fe
80104785:	e8 9f be ff ff       	call   80100629 <cprintf>
    cprintf("$ ");  // simulate shell prompt
8010478a:	c7 04 24 7a 88 10 80 	movl   $0x8010887a,(%esp)
80104791:	e8 93 be ff ff       	call   80100629 <cprintf>
    return;
80104796:	83 c4 10             	add    $0x10,%esp
80104799:	e9 10 01 00 00       	jmp    801048ae <printList+0x186>
    printReadyLists();
8010479e:	e8 8e ef ff ff       	call   80103731 <printReadyLists>
    release(&ptable.lock);
801047a3:	83 ec 0c             	sub    $0xc,%esp
801047a6:	68 e0 b5 10 80       	push   $0x8010b5e0
801047ab:	e8 54 09 00 00       	call   80105104 <release>
    cprintf("$ ");  // simulate shell prompt
801047b0:	c7 04 24 7a 88 10 80 	movl   $0x8010887a,(%esp)
801047b7:	e8 6d be ff ff       	call   80100629 <cprintf>
    return;
801047bc:	83 c4 10             	add    $0x10,%esp
801047bf:	e9 ea 00 00 00       	jmp    801048ae <printList+0x186>
      cprintf("Error: PID %d on %s list but should be on %s\n",
801047c4:	ff 34 bd 3c 89 10 80 	pushl  -0x7fef76c4(,%edi,4)
801047cb:	ff 34 85 3c 89 10 80 	pushl  -0x7fef76c4(,%eax,4)
801047d2:	ff 73 10             	pushl  0x10(%ebx)
801047d5:	68 ec 85 10 80       	push   $0x801085ec
801047da:	e8 4a be ff ff       	call   80100629 <cprintf>
      panic("Corrupted list\n");
801047df:	c7 04 24 2d 88 10 80 	movl   $0x8010882d,(%esp)
801047e6:	e8 71 bb ff ff       	call   8010035c <panic>
      cprintf("(%d, %d)", p->pid,
801047eb:	8b 43 10             	mov    0x10(%ebx),%eax
801047ee:	83 ec 04             	sub    $0x4,%esp
801047f1:	50                   	push   %eax
801047f2:	ff 73 10             	pushl  0x10(%ebx)
801047f5:	68 3d 88 10 80       	push   $0x8010883d
801047fa:	e8 2a be ff ff       	call   80100629 <cprintf>
801047ff:	83 c4 10             	add    $0x10,%esp
    p = p->next;
80104802:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
    cprintf("%s", p ? " -> " : "\n");
80104808:	85 db                	test   %ebx,%ebx
8010480a:	74 66                	je     80104872 <printList+0x14a>
8010480c:	b8 16 87 10 80       	mov    $0x80108716,%eax
80104811:	83 ec 08             	sub    $0x8,%esp
80104814:	50                   	push   %eax
80104815:	68 29 87 10 80       	push   $0x80108729
8010481a:	e8 0a be ff ff       	call   80100629 <cprintf>
    if (p && (++count) %
8010481f:	83 c4 10             	add    $0x10,%esp
80104822:	85 db                	test   %ebx,%ebx
80104824:	74 16                	je     8010483c <printList+0x114>
80104826:	83 c6 01             	add    $0x1,%esi
        ((state == ZOMBIE) ? PER_LINE_Z : PER_LINE) == 0)
80104829:	83 ff 05             	cmp    $0x5,%edi
8010482c:	74 4b                	je     80104879 <printList+0x151>
8010482e:	b9 0f 00 00 00       	mov    $0xf,%ecx
    if (p && (++count) %
80104833:	89 f0                	mov    %esi,%eax
80104835:	99                   	cltd   
80104836:	f7 f9                	idiv   %ecx
80104838:	85 d2                	test   %edx,%edx
8010483a:	74 44                	je     80104880 <printList+0x158>
  while (p != NULL) {
8010483c:	85 db                	test   %ebx,%ebx
8010483e:	74 52                	je     80104892 <printList+0x16a>
    if (p->state != state) {  // sanity check
80104840:	8b 43 0c             	mov    0xc(%ebx),%eax
80104843:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
80104846:	0f 85 78 ff ff ff    	jne    801047c4 <printList+0x9c>
    if (state == ZOMBIE)
8010484c:	83 ff 05             	cmp    $0x5,%edi
8010484f:	75 0c                	jne    8010485d <printList+0x135>
          (p->parent) ? p->parent->pid : p->pid);
80104851:	8b 43 14             	mov    0x14(%ebx),%eax
      cprintf("(%d, %d)", p->pid,
80104854:	85 c0                	test   %eax,%eax
80104856:	74 93                	je     801047eb <printList+0xc3>
80104858:	8b 40 10             	mov    0x10(%eax),%eax
8010485b:	eb 91                	jmp    801047ee <printList+0xc6>
      cprintf("%d", p->pid);
8010485d:	83 ec 08             	sub    $0x8,%esp
80104860:	ff 73 10             	pushl  0x10(%ebx)
80104863:	68 26 87 10 80       	push   $0x80108726
80104868:	e8 bc bd ff ff       	call   80100629 <cprintf>
8010486d:	83 c4 10             	add    $0x10,%esp
80104870:	eb 90                	jmp    80104802 <printList+0xda>
    cprintf("%s", p ? " -> " : "\n");
80104872:	b8 7b 8c 10 80       	mov    $0x80108c7b,%eax
80104877:	eb 98                	jmp    80104811 <printList+0xe9>
        ((state == ZOMBIE) ? PER_LINE_Z : PER_LINE) == 0)
80104879:	b9 07 00 00 00       	mov    $0x7,%ecx
8010487e:	eb b3                	jmp    80104833 <printList+0x10b>
      cprintf("\n");
80104880:	83 ec 0c             	sub    $0xc,%esp
80104883:	68 7b 8c 10 80       	push   $0x80108c7b
80104888:	e8 9c bd ff ff       	call   80100629 <cprintf>
8010488d:	83 c4 10             	add    $0x10,%esp
80104890:	eb aa                	jmp    8010483c <printList+0x114>
  release(&ptable.lock);
80104892:	83 ec 0c             	sub    $0xc,%esp
80104895:	68 e0 b5 10 80       	push   $0x8010b5e0
8010489a:	e8 65 08 00 00       	call   80105104 <release>
  cprintf("$ ");  // simulate shell prompt
8010489f:	c7 04 24 7a 88 10 80 	movl   $0x8010887a,(%esp)
801048a6:	e8 7e bd ff ff       	call   80100629 <cprintf>
  return;
801048ab:	83 c4 10             	add    $0x10,%esp
}
801048ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048b1:	5b                   	pop    %ebx
801048b2:	5e                   	pop    %esi
801048b3:	5f                   	pop    %edi
801048b4:	5d                   	pop    %ebp
801048b5:	c3                   	ret    

801048b6 <printFreeList>:
{
801048b6:	f3 0f 1e fb          	endbr32 
801048ba:	55                   	push   %ebp
801048bb:	89 e5                	mov    %esp,%ebp
801048bd:	53                   	push   %ebx
801048be:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801048c1:	68 e0 b5 10 80       	push   $0x8010b5e0
801048c6:	e8 d0 07 00 00       	call   8010509b <acquire>
  p = ptable.list[UNUSED].head;
801048cb:	a1 14 dd 10 80       	mov    0x8010dd14,%eax
  while (p != NULL) {
801048d0:	83 c4 10             	add    $0x10,%esp
  int count = 0;
801048d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  while (p != NULL) {
801048d8:	85 c0                	test   %eax,%eax
801048da:	74 0b                	je     801048e7 <printFreeList+0x31>
    count++;
801048dc:	83 c3 01             	add    $0x1,%ebx
    p = p->next;
801048df:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801048e5:	eb f1                	jmp    801048d8 <printFreeList+0x22>
  release(&ptable.lock);
801048e7:	83 ec 0c             	sub    $0xc,%esp
801048ea:	68 e0 b5 10 80       	push   $0x8010b5e0
801048ef:	e8 10 08 00 00       	call   80105104 <release>
  cprintf("\nFree List Size: %d processes\n", count);
801048f4:	83 c4 08             	add    $0x8,%esp
801048f7:	53                   	push   %ebx
801048f8:	68 1c 86 10 80       	push   $0x8010861c
801048fd:	e8 27 bd ff ff       	call   80100629 <cprintf>
  cprintf("$ ");  // simulate shell prompt
80104902:	c7 04 24 7a 88 10 80 	movl   $0x8010887a,(%esp)
80104909:	e8 1b bd ff ff       	call   80100629 <cprintf>
  return;
8010490e:	83 c4 10             	add    $0x10,%esp
}
80104911:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104914:	c9                   	leave  
80104915:	c3                   	ret    

80104916 <printListStats>:
{
80104916:	f3 0f 1e fb          	endbr32 
8010491a:	55                   	push   %ebp
8010491b:	89 e5                	mov    %esp,%ebp
8010491d:	57                   	push   %edi
8010491e:	56                   	push   %esi
8010491f:	53                   	push   %ebx
80104920:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
80104923:	68 e0 b5 10 80       	push   $0x8010b5e0
80104928:	e8 6e 07 00 00       	call   8010509b <acquire>
  for (i=UNUSED; i<=ZOMBIE; i++) {
8010492d:	83 c4 10             	add    $0x10,%esp
  int i, count, total = 0;
80104930:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  for (i=UNUSED; i<=ZOMBIE; i++) {
80104937:	bf 00 00 00 00       	mov    $0x0,%edi
8010493c:	eb 67                	jmp    801049a5 <printListStats+0x8f>
        cprintf("\nlist invariant failed: process %d has state %s but is on list %s\n",
8010493e:	ff 34 bd 3c 89 10 80 	pushl  -0x7fef76c4(,%edi,4)
80104945:	ff 34 85 3c 89 10 80 	pushl  -0x7fef76c4(,%eax,4)
8010494c:	ff 73 10             	pushl  0x10(%ebx)
8010494f:	68 3c 86 10 80       	push   $0x8010863c
80104954:	e8 d0 bc ff ff       	call   80100629 <cprintf>
80104959:	83 c4 10             	add    $0x10,%esp
      p = p->next;
8010495c:	8b 9b 90 00 00 00    	mov    0x90(%ebx),%ebx
    while (p != NULL) {
80104962:	85 db                	test   %ebx,%ebx
80104964:	74 0c                	je     80104972 <printListStats+0x5c>
      count++;
80104966:	83 c6 01             	add    $0x1,%esi
      if(p->state != i) {
80104969:	8b 43 0c             	mov    0xc(%ebx),%eax
8010496c:	39 f8                	cmp    %edi,%eax
8010496e:	74 ec                	je     8010495c <printListStats+0x46>
80104970:	eb cc                	jmp    8010493e <printListStats+0x28>
    cprintf("\n%s list has ", states[i]);
80104972:	83 ec 08             	sub    $0x8,%esp
80104975:	ff 34 bd 3c 89 10 80 	pushl  -0x7fef76c4(,%edi,4)
8010497c:	68 5e 88 10 80       	push   $0x8010885e
80104981:	e8 a3 bc ff ff       	call   80100629 <cprintf>
    if (count < 10) cprintf(" ");  // line up columns. we know NPROC < 100
80104986:	83 c4 10             	add    $0x10,%esp
80104989:	83 fe 09             	cmp    $0x9,%esi
8010498c:	7e 2a                	jle    801049b8 <printListStats+0xa2>
    cprintf("%d processes", count);
8010498e:	83 ec 08             	sub    $0x8,%esp
80104991:	56                   	push   %esi
80104992:	68 6c 88 10 80       	push   $0x8010886c
80104997:	e8 8d bc ff ff       	call   80100629 <cprintf>
    total += count;
8010499c:	01 75 e4             	add    %esi,-0x1c(%ebp)
  for (i=UNUSED; i<=ZOMBIE; i++) {
8010499f:	83 c7 01             	add    $0x1,%edi
801049a2:	83 c4 10             	add    $0x10,%esp
801049a5:	83 ff 05             	cmp    $0x5,%edi
801049a8:	7f 20                	jg     801049ca <printListStats+0xb4>
    p = ptable.list[i].head;
801049aa:	8b 1c fd 14 dd 10 80 	mov    -0x7fef22ec(,%edi,8),%ebx
    count = 0;
801049b1:	be 00 00 00 00       	mov    $0x0,%esi
    while (p != NULL) {
801049b6:	eb aa                	jmp    80104962 <printListStats+0x4c>
    if (count < 10) cprintf(" ");  // line up columns. we know NPROC < 100
801049b8:	83 ec 0c             	sub    $0xc,%esp
801049bb:	68 bc 88 10 80       	push   $0x801088bc
801049c0:	e8 64 bc ff ff       	call   80100629 <cprintf>
801049c5:	83 c4 10             	add    $0x10,%esp
801049c8:	eb c4                	jmp    8010498e <printListStats+0x78>
  release(&ptable.lock);
801049ca:	83 ec 0c             	sub    $0xc,%esp
801049cd:	68 e0 b5 10 80       	push   $0x8010b5e0
801049d2:	e8 2d 07 00 00       	call   80105104 <release>
  cprintf("\nTotal on lists is: %d. NPROC = %d. %s",
801049d7:	83 c4 10             	add    $0x10,%esp
801049da:	83 7d e4 40          	cmpl   $0x40,-0x1c(%ebp)
801049de:	74 2c                	je     80104a0c <printListStats+0xf6>
801049e0:	b8 46 88 10 80       	mov    $0x80108846,%eax
801049e5:	50                   	push   %eax
801049e6:	6a 40                	push   $0x40
801049e8:	ff 75 e4             	pushl  -0x1c(%ebp)
801049eb:	68 80 86 10 80       	push   $0x80108680
801049f0:	e8 34 bc ff ff       	call   80100629 <cprintf>
  cprintf("\n$ ");  // simulate shell prompt
801049f5:	c7 04 24 79 88 10 80 	movl   $0x80108879,(%esp)
801049fc:	e8 28 bc ff ff       	call   80100629 <cprintf>
  return;
80104a01:	83 c4 10             	add    $0x10,%esp
}
80104a04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a07:	5b                   	pop    %ebx
80104a08:	5e                   	pop    %esi
80104a09:	5f                   	pop    %edi
80104a0a:	5d                   	pop    %ebp
80104a0b:	c3                   	ret    
  cprintf("\nTotal on lists is: %d. NPROC = %d. %s",
80104a0c:	b8 4d 88 10 80       	mov    $0x8010884d,%eax
80104a11:	eb d2                	jmp    801049e5 <printListStats+0xcf>

80104a13 <setpriority>:
{
80104a13:	f3 0f 1e fb          	endbr32 
80104a17:	55                   	push   %ebp
80104a18:	89 e5                	mov    %esp,%ebp
80104a1a:	57                   	push   %edi
80104a1b:	56                   	push   %esi
80104a1c:	53                   	push   %ebx
80104a1d:	83 ec 18             	sub    $0x18,%esp
80104a20:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a23:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&ptable.lock);
80104a26:	68 e0 b5 10 80       	push   $0x8010b5e0
80104a2b:	e8 6b 06 00 00       	call   8010509b <acquire>
  if(pid < 0 || priority < 0 || priority > MAXPRIO)
80104a30:	89 d8                	mov    %ebx,%eax
80104a32:	c1 e8 1f             	shr    $0x1f,%eax
80104a35:	89 f2                	mov    %esi,%edx
80104a37:	c1 ea 1f             	shr    $0x1f,%edx
80104a3a:	83 c4 10             	add    $0x10,%esp
80104a3d:	89 d1                	mov    %edx,%ecx
80104a3f:	08 c1                	or     %al,%cl
80104a41:	0f 85 cb 01 00 00    	jne    80104c12 <setpriority+0x1ff>
80104a47:	83 fe 06             	cmp    $0x6,%esi
80104a4a:	0f 8f cc 01 00 00    	jg     80104c1c <setpriority+0x209>
  p = ptable.list[RUNNING].head;
80104a50:	a1 34 dd 10 80       	mov    0x8010dd34,%eax
  while(p != NULL) {
80104a55:	85 c0                	test   %eax,%eax
80104a57:	74 3a                	je     80104a93 <setpriority+0x80>
    if(p->pid == pid) {
80104a59:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a5c:	74 08                	je     80104a66 <setpriority+0x53>
    p = p->next;
80104a5e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104a64:	eb ef                	jmp    80104a55 <setpriority+0x42>
      p->priority = priority;
80104a66:	89 b0 94 00 00 00    	mov    %esi,0x94(%eax)
      p->budget = BUDGET;
80104a6c:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80104a73:	01 00 00 
      release(&ptable.lock);
80104a76:	83 ec 0c             	sub    $0xc,%esp
80104a79:	68 e0 b5 10 80       	push   $0x8010b5e0
80104a7e:	e8 81 06 00 00       	call   80105104 <release>
      return 0;
80104a83:	83 c4 10             	add    $0x10,%esp
80104a86:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a8e:	5b                   	pop    %ebx
80104a8f:	5e                   	pop    %esi
80104a90:	5f                   	pop    %edi
80104a91:	5d                   	pop    %ebp
80104a92:	c3                   	ret    
  for(int i = MAXPRIO; i >= 0 ; --i) {
80104a93:	b8 06 00 00 00       	mov    $0x6,%eax
80104a98:	85 c0                	test   %eax,%eax
80104a9a:	0f 88 98 00 00 00    	js     80104b38 <setpriority+0x125>
    p = ptable.ready[i].head;
80104aa0:	8b 3c c5 44 dd 10 80 	mov    -0x7fef22bc(,%eax,8),%edi
    while(p != NULL) {
80104aa7:	85 ff                	test   %edi,%edi
80104aa9:	75 05                	jne    80104ab0 <setpriority+0x9d>
  for(int i = MAXPRIO; i >= 0 ; --i) {
80104aab:	83 e8 01             	sub    $0x1,%eax
80104aae:	eb e8                	jmp    80104a98 <setpriority+0x85>
      if(p->pid == pid) {
80104ab0:	39 5f 10             	cmp    %ebx,0x10(%edi)
80104ab3:	75 69                	jne    80104b1e <setpriority+0x10b>
        p->priority = priority;
80104ab5:	89 b7 94 00 00 00    	mov    %esi,0x94(%edi)
        p->budget = BUDGET;
80104abb:	c7 87 98 00 00 00 2c 	movl   $0x12c,0x98(%edi)
80104ac2:	01 00 00 
        if(priority != i) {
80104ac5:	39 f0                	cmp    %esi,%eax
80104ac7:	74 2e                	je     80104af7 <setpriority+0xe4>
          if(stateListRemove(&ptable.ready[i], p) == -1){
80104ac9:	8d 04 c5 44 dd 10 80 	lea    -0x7fef22bc(,%eax,8),%eax
80104ad0:	89 fa                	mov    %edi,%edx
80104ad2:	e8 0b e7 ff ff       	call   801031e2 <stateListRemove>
80104ad7:	83 f8 ff             	cmp    $0xffffffff,%eax
80104ada:	74 35                	je     80104b11 <setpriority+0xfe>
          stateListAdd(&ptable.ready[priority+1], p);
80104adc:	8d 04 f5 4c dd 10 80 	lea    -0x7fef22b4(,%esi,8),%eax
80104ae3:	89 fa                	mov    %edi,%edx
80104ae5:	e8 c3 e6 ff ff       	call   801031ad <stateListAdd>
          assert_prio(p, p->priority);
80104aea:	8b 97 94 00 00 00    	mov    0x94(%edi),%edx
80104af0:	89 f8                	mov    %edi,%eax
80104af2:	e8 46 eb ff ff       	call   8010363d <assert_prio>
        release(&ptable.lock);
80104af7:	83 ec 0c             	sub    $0xc,%esp
80104afa:	68 e0 b5 10 80       	push   $0x8010b5e0
80104aff:	e8 00 06 00 00       	call   80105104 <release>
        return 0;
80104b04:	83 c4 10             	add    $0x10,%esp
80104b07:	b8 00 00 00 00       	mov    $0x0,%eax
80104b0c:	e9 7a ff ff ff       	jmp    80104a8b <setpriority+0x78>
            panic("failed to remove process from RUNNING list in setpriority()\n");
80104b11:	83 ec 0c             	sub    $0xc,%esp
80104b14:	68 a8 86 10 80       	push   $0x801086a8
80104b19:	e8 3e b8 ff ff       	call   8010035c <panic>
      release(&ptable.lock);
80104b1e:	83 ec 0c             	sub    $0xc,%esp
80104b21:	68 e0 b5 10 80       	push   $0x8010b5e0
80104b26:	e8 d9 05 00 00       	call   80105104 <release>
      return 0;
80104b2b:	83 c4 10             	add    $0x10,%esp
80104b2e:	b8 00 00 00 00       	mov    $0x0,%eax
80104b33:	e9 53 ff ff ff       	jmp    80104a8b <setpriority+0x78>
  p = ptable.list[SLEEPING].head;
80104b38:	a1 24 dd 10 80       	mov    0x8010dd24,%eax
  while(p != NULL) {
80104b3d:	85 c0                	test   %eax,%eax
80104b3f:	74 37                	je     80104b78 <setpriority+0x165>
    if(p->pid == pid) {
80104b41:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b44:	74 08                	je     80104b4e <setpriority+0x13b>
    p = p->next;
80104b46:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104b4c:	eb ef                	jmp    80104b3d <setpriority+0x12a>
      p->priority = priority;
80104b4e:	89 b0 94 00 00 00    	mov    %esi,0x94(%eax)
      p->budget = BUDGET;
80104b54:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80104b5b:	01 00 00 
      release(&ptable.lock);
80104b5e:	83 ec 0c             	sub    $0xc,%esp
80104b61:	68 e0 b5 10 80       	push   $0x8010b5e0
80104b66:	e8 99 05 00 00       	call   80105104 <release>
      return 0;
80104b6b:	83 c4 10             	add    $0x10,%esp
80104b6e:	b8 00 00 00 00       	mov    $0x0,%eax
80104b73:	e9 13 ff ff ff       	jmp    80104a8b <setpriority+0x78>
  p = ptable.list[EMBRYO].head;
80104b78:	a1 1c dd 10 80       	mov    0x8010dd1c,%eax
  while(p != NULL) {
80104b7d:	85 c0                	test   %eax,%eax
80104b7f:	74 37                	je     80104bb8 <setpriority+0x1a5>
    if(p->pid == pid) {
80104b81:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b84:	74 08                	je     80104b8e <setpriority+0x17b>
    p = p->next;
80104b86:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104b8c:	eb ef                	jmp    80104b7d <setpriority+0x16a>
      p->priority = priority;
80104b8e:	89 b0 94 00 00 00    	mov    %esi,0x94(%eax)
      p->budget = BUDGET;
80104b94:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80104b9b:	01 00 00 
      release(&ptable.lock);
80104b9e:	83 ec 0c             	sub    $0xc,%esp
80104ba1:	68 e0 b5 10 80       	push   $0x8010b5e0
80104ba6:	e8 59 05 00 00       	call   80105104 <release>
      return 0;
80104bab:	83 c4 10             	add    $0x10,%esp
80104bae:	b8 00 00 00 00       	mov    $0x0,%eax
80104bb3:	e9 d3 fe ff ff       	jmp    80104a8b <setpriority+0x78>
  p = ptable.list[ZOMBIE].head;
80104bb8:	a1 3c dd 10 80       	mov    0x8010dd3c,%eax
  while(p != NULL) {
80104bbd:	eb 06                	jmp    80104bc5 <setpriority+0x1b2>
    p = p->next;
80104bbf:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  while(p != NULL) {
80104bc5:	85 c0                	test   %eax,%eax
80104bc7:	74 2f                	je     80104bf8 <setpriority+0x1e5>
    if(p->pid == pid) {
80104bc9:	39 58 10             	cmp    %ebx,0x10(%eax)
80104bcc:	75 f1                	jne    80104bbf <setpriority+0x1ac>
      p->priority = priority;
80104bce:	89 b0 94 00 00 00    	mov    %esi,0x94(%eax)
      p->budget = BUDGET;
80104bd4:	c7 80 98 00 00 00 2c 	movl   $0x12c,0x98(%eax)
80104bdb:	01 00 00 
      release(&ptable.lock);
80104bde:	83 ec 0c             	sub    $0xc,%esp
80104be1:	68 e0 b5 10 80       	push   $0x8010b5e0
80104be6:	e8 19 05 00 00       	call   80105104 <release>
      return 0;
80104beb:	83 c4 10             	add    $0x10,%esp
80104bee:	b8 00 00 00 00       	mov    $0x0,%eax
80104bf3:	e9 93 fe ff ff       	jmp    80104a8b <setpriority+0x78>
  release(&ptable.lock);
80104bf8:	83 ec 0c             	sub    $0xc,%esp
80104bfb:	68 e0 b5 10 80       	push   $0x8010b5e0
80104c00:	e8 ff 04 00 00       	call   80105104 <release>
  return -1;
80104c05:	83 c4 10             	add    $0x10,%esp
80104c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c0d:	e9 79 fe ff ff       	jmp    80104a8b <setpriority+0x78>
    return -1;
80104c12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c17:	e9 6f fe ff ff       	jmp    80104a8b <setpriority+0x78>
80104c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c21:	e9 65 fe ff ff       	jmp    80104a8b <setpriority+0x78>

80104c26 <getpriority>:
{
80104c26:	f3 0f 1e fb          	endbr32 
80104c2a:	55                   	push   %ebp
80104c2b:	89 e5                	mov    %esp,%ebp
80104c2d:	53                   	push   %ebx
80104c2e:	83 ec 10             	sub    $0x10,%esp
80104c31:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104c34:	68 e0 b5 10 80       	push   $0x8010b5e0
80104c39:	e8 5d 04 00 00       	call   8010509b <acquire>
  p = ptable.list[RUNNING].head;
80104c3e:	a1 34 dd 10 80       	mov    0x8010dd34,%eax
  while(p != NULL) {
80104c43:	83 c4 10             	add    $0x10,%esp
80104c46:	85 c0                	test   %eax,%eax
80104c48:	74 2a                	je     80104c74 <getpriority+0x4e>
    if(p->pid == pid) {
80104c4a:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c4d:	74 08                	je     80104c57 <getpriority+0x31>
    p = p->next;
80104c4f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104c55:	eb ef                	jmp    80104c46 <getpriority+0x20>
      priority = p->priority;
80104c57:	8b 98 94 00 00 00    	mov    0x94(%eax),%ebx
      release(&ptable.lock);
80104c5d:	83 ec 0c             	sub    $0xc,%esp
80104c60:	68 e0 b5 10 80       	push   $0x8010b5e0
80104c65:	e8 9a 04 00 00       	call   80105104 <release>
      return priority;
80104c6a:	83 c4 10             	add    $0x10,%esp
}
80104c6d:	89 d8                	mov    %ebx,%eax
80104c6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c72:	c9                   	leave  
80104c73:	c3                   	ret    
  p = ptable.list[SLEEPING].head;
80104c74:	a1 24 dd 10 80       	mov    0x8010dd24,%eax
  while(p != NULL) {
80104c79:	85 c0                	test   %eax,%eax
80104c7b:	74 25                	je     80104ca2 <getpriority+0x7c>
    if(p->pid == pid) {
80104c7d:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c80:	74 08                	je     80104c8a <getpriority+0x64>
    p = p->next;
80104c82:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104c88:	eb ef                	jmp    80104c79 <getpriority+0x53>
      priority = p->priority;
80104c8a:	8b 98 94 00 00 00    	mov    0x94(%eax),%ebx
      release(&ptable.lock);
80104c90:	83 ec 0c             	sub    $0xc,%esp
80104c93:	68 e0 b5 10 80       	push   $0x8010b5e0
80104c98:	e8 67 04 00 00       	call   80105104 <release>
      return priority;
80104c9d:	83 c4 10             	add    $0x10,%esp
80104ca0:	eb cb                	jmp    80104c6d <getpriority+0x47>
  for(int i = MAXPRIO; i >= 0 ; --i) { 
80104ca2:	ba 06 00 00 00       	mov    $0x6,%edx
80104ca7:	85 d2                	test   %edx,%edx
80104ca9:	78 35                	js     80104ce0 <getpriority+0xba>
    p = ptable.ready[i].head;
80104cab:	8b 04 d5 44 dd 10 80 	mov    -0x7fef22bc(,%edx,8),%eax
    while(p != NULL) {
80104cb2:	85 c0                	test   %eax,%eax
80104cb4:	74 25                	je     80104cdb <getpriority+0xb5>
      if(p->pid == pid) {
80104cb6:	39 58 10             	cmp    %ebx,0x10(%eax)
80104cb9:	74 08                	je     80104cc3 <getpriority+0x9d>
      p = p->next;
80104cbb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104cc1:	eb ef                	jmp    80104cb2 <getpriority+0x8c>
        priority = p->priority;
80104cc3:	8b 98 94 00 00 00    	mov    0x94(%eax),%ebx
        release(&ptable.lock);
80104cc9:	83 ec 0c             	sub    $0xc,%esp
80104ccc:	68 e0 b5 10 80       	push   $0x8010b5e0
80104cd1:	e8 2e 04 00 00       	call   80105104 <release>
        return priority;
80104cd6:	83 c4 10             	add    $0x10,%esp
80104cd9:	eb 92                	jmp    80104c6d <getpriority+0x47>
  for(int i = MAXPRIO; i >= 0 ; --i) { 
80104cdb:	83 ea 01             	sub    $0x1,%edx
80104cde:	eb c7                	jmp    80104ca7 <getpriority+0x81>
  release(&ptable.lock);
80104ce0:	83 ec 0c             	sub    $0xc,%esp
80104ce3:	68 e0 b5 10 80       	push   $0x8010b5e0
80104ce8:	e8 17 04 00 00       	call   80105104 <release>
  cprintf("Process with pid %d not found.\n", pid);
80104ced:	83 c4 08             	add    $0x8,%esp
80104cf0:	53                   	push   %ebx
80104cf1:	68 e8 86 10 80       	push   $0x801086e8
80104cf6:	e8 2e b9 ff ff       	call   80100629 <cprintf>
  return -1;
80104cfb:	83 c4 10             	add    $0x10,%esp
80104cfe:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d03:	e9 65 ff ff ff       	jmp    80104c6d <getpriority+0x47>

80104d08 <getprocs>:
//added in P2
#ifdef CS333_P2
//helper function
int
getprocs(int max, struct uproc * table)
{
80104d08:	f3 0f 1e fb          	endbr32 
80104d0c:	55                   	push   %ebp
80104d0d:	89 e5                	mov    %esp,%ebp
80104d0f:	57                   	push   %edi
80104d10:	56                   	push   %esi
80104d11:	53                   	push   %ebx
80104d12:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
80104d15:	68 e0 b5 10 80       	push   $0x8010b5e0
80104d1a:	e8 7c 03 00 00       	call   8010509b <acquire>
  int i;
  int k;
  k = 0;
  for(i = 0; i < NPROC && k < max; ++i)
80104d1f:	83 c4 10             	add    $0x10,%esp
  k = 0;
80104d22:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  for(i = 0; i < NPROC && k < max; ++i)
80104d29:	be 00 00 00 00       	mov    $0x0,%esi
80104d2e:	eb 38                	jmp    80104d68 <getprocs+0x60>
      table[k].uid = ptable.proc[i].uid;
      table[k].gid = ptable.proc[i].gid;
      if(ptable.proc[i].parent != NULL)
        table[k].ppid = ptable.proc[i].parent->pid;	
      else
        table[k].ppid = ptable.proc[i].pid;
80104d30:	69 c6 9c 00 00 00    	imul   $0x9c,%esi,%eax
80104d36:	8b 80 24 b6 10 80    	mov    -0x7fef49dc(%eax),%eax
80104d3c:	89 43 0c             	mov    %eax,0xc(%ebx)
80104d3f:	e9 a6 00 00 00       	jmp    80104dea <getprocs+0xe2>
      table[k].CPU_total_ticks = ptable.proc[i].cpu_ticks_total;
      table[k].elapsed_ticks = ticks - ptable.proc[i].start_ticks; 
      if(ptable.proc[i].state >= 0 && ptable.proc[i].state < NELEM(states) && states[ptable.proc[i].state])
        safestrcpy(table[k].state, states[ptable.proc[i].state], sizeof(table[k].state)); 	
      table[k].size = ptable.proc[i].sz; 
80104d44:	69 c6 9c 00 00 00    	imul   $0x9c,%esi,%eax
80104d4a:	8b 90 14 b6 10 80    	mov    -0x7fef49ec(%eax),%edx
80104d50:	05 e0 b5 10 80       	add    $0x8010b5e0,%eax
80104d55:	89 53 3c             	mov    %edx,0x3c(%ebx)
#ifdef CS333_P4
      table[k].priority = ptable.proc[i].priority;
80104d58:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
80104d5e:	89 43 10             	mov    %eax,0x10(%ebx)
#endif //CS333_P4
      ++k;
80104d61:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  for(i = 0; i < NPROC && k < max; ++i)
80104d65:	83 c6 01             	add    $0x1,%esi
80104d68:	83 fe 3f             	cmp    $0x3f,%esi
80104d6b:	0f 9e c2             	setle  %dl
80104d6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104d71:	3b 45 08             	cmp    0x8(%ebp),%eax
80104d74:	0f 9c c0             	setl   %al
80104d77:	84 c2                	test   %al,%dl
80104d79:	0f 84 c0 00 00 00    	je     80104e3f <getprocs+0x137>
    if(ptable.proc[i].state == EMBRYO || ptable.proc[i].state == UNUSED)
80104d7f:	69 c6 9c 00 00 00    	imul   $0x9c,%esi,%eax
80104d85:	83 b8 20 b6 10 80 01 	cmpl   $0x1,-0x7fef49e0(%eax)
80104d8c:	76 d7                	jbe    80104d65 <getprocs+0x5d>
      table[k].pid = ptable.proc[i].pid;	
80104d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104d91:	8d 04 40             	lea    (%eax,%eax,2),%eax
80104d94:	c1 e0 05             	shl    $0x5,%eax
80104d97:	89 c3                	mov    %eax,%ebx
80104d99:	03 5d 0c             	add    0xc(%ebp),%ebx
80104d9c:	69 c6 9c 00 00 00    	imul   $0x9c,%esi,%eax
80104da2:	8d b8 e0 b5 10 80    	lea    -0x7fef4a20(%eax),%edi
80104da8:	8b 90 24 b6 10 80    	mov    -0x7fef49dc(%eax),%edx
80104dae:	89 13                	mov    %edx,(%ebx)
      safestrcpy(table[k].name, ptable.proc[i].name, sizeof(table[k].name));
80104db0:	05 80 b6 10 80       	add    $0x8010b680,%eax
80104db5:	8d 53 40             	lea    0x40(%ebx),%edx
80104db8:	83 ec 04             	sub    $0x4,%esp
80104dbb:	6a 20                	push   $0x20
80104dbd:	50                   	push   %eax
80104dbe:	52                   	push   %edx
80104dbf:	e8 0b 05 00 00       	call   801052cf <safestrcpy>
      table[k].uid = ptable.proc[i].uid;
80104dc4:	8b 87 b4 00 00 00    	mov    0xb4(%edi),%eax
80104dca:	89 43 04             	mov    %eax,0x4(%ebx)
      table[k].gid = ptable.proc[i].gid;
80104dcd:	8b 87 b8 00 00 00    	mov    0xb8(%edi),%eax
80104dd3:	89 43 08             	mov    %eax,0x8(%ebx)
      if(ptable.proc[i].parent != NULL)
80104dd6:	8b 47 48             	mov    0x48(%edi),%eax
80104dd9:	83 c4 10             	add    $0x10,%esp
80104ddc:	85 c0                	test   %eax,%eax
80104dde:	0f 84 4c ff ff ff    	je     80104d30 <getprocs+0x28>
        table[k].ppid = ptable.proc[i].parent->pid;	
80104de4:	8b 40 10             	mov    0x10(%eax),%eax
80104de7:	89 43 0c             	mov    %eax,0xc(%ebx)
      table[k].CPU_total_ticks = ptable.proc[i].cpu_ticks_total;
80104dea:	69 c6 9c 00 00 00    	imul   $0x9c,%esi,%eax
80104df0:	8b 90 9c b6 10 80    	mov    -0x7fef4964(%eax),%edx
80104df6:	89 53 18             	mov    %edx,0x18(%ebx)
      table[k].elapsed_ticks = ticks - ptable.proc[i].start_ticks; 
80104df9:	8b 15 00 6d 11 80    	mov    0x80116d00,%edx
80104dff:	2b 90 90 b6 10 80    	sub    -0x7fef4970(%eax),%edx
      table[k].CPU_total_ticks = ptable.proc[i].cpu_ticks_total;
80104e05:	05 e0 b5 10 80       	add    $0x8010b5e0,%eax
      table[k].elapsed_ticks = ticks - ptable.proc[i].start_ticks; 
80104e0a:	89 53 14             	mov    %edx,0x14(%ebx)
      if(ptable.proc[i].state >= 0 && ptable.proc[i].state < NELEM(states) && states[ptable.proc[i].state])
80104e0d:	8b 40 40             	mov    0x40(%eax),%eax
80104e10:	83 f8 05             	cmp    $0x5,%eax
80104e13:	0f 87 2b ff ff ff    	ja     80104d44 <getprocs+0x3c>
80104e19:	8b 04 85 3c 89 10 80 	mov    -0x7fef76c4(,%eax,4),%eax
80104e20:	85 c0                	test   %eax,%eax
80104e22:	0f 84 1c ff ff ff    	je     80104d44 <getprocs+0x3c>
        safestrcpy(table[k].state, states[ptable.proc[i].state], sizeof(table[k].state)); 	
80104e28:	8d 53 1c             	lea    0x1c(%ebx),%edx
80104e2b:	83 ec 04             	sub    $0x4,%esp
80104e2e:	6a 20                	push   $0x20
80104e30:	50                   	push   %eax
80104e31:	52                   	push   %edx
80104e32:	e8 98 04 00 00       	call   801052cf <safestrcpy>
80104e37:	83 c4 10             	add    $0x10,%esp
80104e3a:	e9 05 ff ff ff       	jmp    80104d44 <getprocs+0x3c>
    }
  }
  release(&ptable.lock);
80104e3f:	83 ec 0c             	sub    $0xc,%esp
80104e42:	68 e0 b5 10 80       	push   $0x8010b5e0
80104e47:	e8 b8 02 00 00       	call   80105104 <release>
    
  return k; 
}
80104e4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e52:	5b                   	pop    %ebx
80104e53:	5e                   	pop    %esi
80104e54:	5f                   	pop    %edi
80104e55:	5d                   	pop    %ebp
80104e56:	c3                   	ret    

80104e57 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104e57:	f3 0f 1e fb          	endbr32 
80104e5b:	55                   	push   %ebp
80104e5c:	89 e5                	mov    %esp,%ebp
80104e5e:	53                   	push   %ebx
80104e5f:	83 ec 0c             	sub    $0xc,%esp
80104e62:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104e65:	68 54 89 10 80       	push   $0x80108954
80104e6a:	8d 43 04             	lea    0x4(%ebx),%eax
80104e6d:	50                   	push   %eax
80104e6e:	e8 d8 00 00 00       	call   80104f4b <initlock>
  lk->name = name;
80104e73:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e76:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80104e79:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104e7f:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80104e86:	83 c4 10             	add    $0x10,%esp
80104e89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e8c:	c9                   	leave  
80104e8d:	c3                   	ret    

80104e8e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104e8e:	f3 0f 1e fb          	endbr32 
80104e92:	55                   	push   %ebp
80104e93:	89 e5                	mov    %esp,%ebp
80104e95:	56                   	push   %esi
80104e96:	53                   	push   %ebx
80104e97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104e9a:	8d 73 04             	lea    0x4(%ebx),%esi
80104e9d:	83 ec 0c             	sub    $0xc,%esp
80104ea0:	56                   	push   %esi
80104ea1:	e8 f5 01 00 00       	call   8010509b <acquire>
  while (lk->locked) {
80104ea6:	83 c4 10             	add    $0x10,%esp
80104ea9:	83 3b 00             	cmpl   $0x0,(%ebx)
80104eac:	74 0f                	je     80104ebd <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80104eae:	83 ec 08             	sub    $0x8,%esp
80104eb1:	56                   	push   %esi
80104eb2:	53                   	push   %ebx
80104eb3:	e8 29 f2 ff ff       	call   801040e1 <sleep>
80104eb8:	83 c4 10             	add    $0x10,%esp
80104ebb:	eb ec                	jmp    80104ea9 <acquiresleep+0x1b>
  }
  lk->locked = 1;
80104ebd:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ec3:	e8 c0 e9 ff ff       	call   80103888 <myproc>
80104ec8:	8b 40 10             	mov    0x10(%eax),%eax
80104ecb:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ece:	83 ec 0c             	sub    $0xc,%esp
80104ed1:	56                   	push   %esi
80104ed2:	e8 2d 02 00 00       	call   80105104 <release>
}
80104ed7:	83 c4 10             	add    $0x10,%esp
80104eda:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104edd:	5b                   	pop    %ebx
80104ede:	5e                   	pop    %esi
80104edf:	5d                   	pop    %ebp
80104ee0:	c3                   	ret    

80104ee1 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104ee1:	f3 0f 1e fb          	endbr32 
80104ee5:	55                   	push   %ebp
80104ee6:	89 e5                	mov    %esp,%ebp
80104ee8:	56                   	push   %esi
80104ee9:	53                   	push   %ebx
80104eea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104eed:	8d 73 04             	lea    0x4(%ebx),%esi
80104ef0:	83 ec 0c             	sub    $0xc,%esp
80104ef3:	56                   	push   %esi
80104ef4:	e8 a2 01 00 00       	call   8010509b <acquire>
  lk->locked = 0;
80104ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104eff:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104f06:	89 1c 24             	mov    %ebx,(%esp)
80104f09:	e8 d2 f4 ff ff       	call   801043e0 <wakeup>
  release(&lk->lk);
80104f0e:	89 34 24             	mov    %esi,(%esp)
80104f11:	e8 ee 01 00 00       	call   80105104 <release>
}
80104f16:	83 c4 10             	add    $0x10,%esp
80104f19:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f1c:	5b                   	pop    %ebx
80104f1d:	5e                   	pop    %esi
80104f1e:	5d                   	pop    %ebp
80104f1f:	c3                   	ret    

80104f20 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104f20:	f3 0f 1e fb          	endbr32 
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	56                   	push   %esi
80104f28:	53                   	push   %ebx
80104f29:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104f2c:	8d 5e 04             	lea    0x4(%esi),%ebx
80104f2f:	83 ec 0c             	sub    $0xc,%esp
80104f32:	53                   	push   %ebx
80104f33:	e8 63 01 00 00       	call   8010509b <acquire>
  r = lk->locked;
80104f38:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104f3a:	89 1c 24             	mov    %ebx,(%esp)
80104f3d:	e8 c2 01 00 00       	call   80105104 <release>
  return r;
}
80104f42:	89 f0                	mov    %esi,%eax
80104f44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f47:	5b                   	pop    %ebx
80104f48:	5e                   	pop    %esi
80104f49:	5d                   	pop    %ebp
80104f4a:	c3                   	ret    

80104f4b <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f4b:	f3 0f 1e fb          	endbr32 
80104f4f:	55                   	push   %ebp
80104f50:	89 e5                	mov    %esp,%ebp
80104f52:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104f55:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f58:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104f5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f61:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f68:	5d                   	pop    %ebp
80104f69:	c3                   	ret    

80104f6a <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104f6a:	f3 0f 1e fb          	endbr32 
80104f6e:	55                   	push   %ebp
80104f6f:	89 e5                	mov    %esp,%ebp
80104f71:	53                   	push   %ebx
80104f72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104f75:	8b 45 08             	mov    0x8(%ebp),%eax
80104f78:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104f7b:	b8 00 00 00 00       	mov    $0x0,%eax
80104f80:	83 f8 09             	cmp    $0x9,%eax
80104f83:	7f 25                	jg     80104faa <getcallerpcs+0x40>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104f85:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104f8b:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104f91:	77 17                	ja     80104faa <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104f93:	8b 5a 04             	mov    0x4(%edx),%ebx
80104f96:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80104f99:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104f9b:	83 c0 01             	add    $0x1,%eax
80104f9e:	eb e0                	jmp    80104f80 <getcallerpcs+0x16>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104fa0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80104fa7:	83 c0 01             	add    $0x1,%eax
80104faa:	83 f8 09             	cmp    $0x9,%eax
80104fad:	7e f1                	jle    80104fa0 <getcallerpcs+0x36>
}
80104faf:	5b                   	pop    %ebx
80104fb0:	5d                   	pop    %ebp
80104fb1:	c3                   	ret    

80104fb2 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104fb2:	f3 0f 1e fb          	endbr32 
80104fb6:	55                   	push   %ebp
80104fb7:	89 e5                	mov    %esp,%ebp
80104fb9:	53                   	push   %ebx
80104fba:	83 ec 04             	sub    $0x4,%esp
80104fbd:	9c                   	pushf  
80104fbe:	5b                   	pop    %ebx
  asm volatile("cli");
80104fbf:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104fc0:	e8 44 e8 ff ff       	call   80103809 <mycpu>
80104fc5:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80104fcc:	74 12                	je     80104fe0 <pushcli+0x2e>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104fce:	e8 36 e8 ff ff       	call   80103809 <mycpu>
80104fd3:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104fda:	83 c4 04             	add    $0x4,%esp
80104fdd:	5b                   	pop    %ebx
80104fde:	5d                   	pop    %ebp
80104fdf:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80104fe0:	e8 24 e8 ff ff       	call   80103809 <mycpu>
80104fe5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104feb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104ff1:	eb db                	jmp    80104fce <pushcli+0x1c>

80104ff3 <popcli>:

void
popcli(void)
{
80104ff3:	f3 0f 1e fb          	endbr32 
80104ff7:	55                   	push   %ebp
80104ff8:	89 e5                	mov    %esp,%ebp
80104ffa:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ffd:	9c                   	pushf  
80104ffe:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104fff:	f6 c4 02             	test   $0x2,%ah
80105002:	75 28                	jne    8010502c <popcli+0x39>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105004:	e8 00 e8 ff ff       	call   80103809 <mycpu>
80105009:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
8010500f:	8d 51 ff             	lea    -0x1(%ecx),%edx
80105012:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80105018:	85 d2                	test   %edx,%edx
8010501a:	78 1d                	js     80105039 <popcli+0x46>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010501c:	e8 e8 e7 ff ff       	call   80103809 <mycpu>
80105021:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80105028:	74 1c                	je     80105046 <popcli+0x53>
    sti();
}
8010502a:	c9                   	leave  
8010502b:	c3                   	ret    
    panic("popcli - interruptible");
8010502c:	83 ec 0c             	sub    $0xc,%esp
8010502f:	68 5f 89 10 80       	push   $0x8010895f
80105034:	e8 23 b3 ff ff       	call   8010035c <panic>
    panic("popcli");
80105039:	83 ec 0c             	sub    $0xc,%esp
8010503c:	68 76 89 10 80       	push   $0x80108976
80105041:	e8 16 b3 ff ff       	call   8010035c <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105046:	e8 be e7 ff ff       	call   80103809 <mycpu>
8010504b:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80105052:	74 d6                	je     8010502a <popcli+0x37>
  asm volatile("sti");
80105054:	fb                   	sti    
}
80105055:	eb d3                	jmp    8010502a <popcli+0x37>

80105057 <holding>:
{
80105057:	f3 0f 1e fb          	endbr32 
8010505b:	55                   	push   %ebp
8010505c:	89 e5                	mov    %esp,%ebp
8010505e:	53                   	push   %ebx
8010505f:	83 ec 04             	sub    $0x4,%esp
80105062:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105065:	e8 48 ff ff ff       	call   80104fb2 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010506a:	83 3b 00             	cmpl   $0x0,(%ebx)
8010506d:	75 12                	jne    80105081 <holding+0x2a>
8010506f:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80105074:	e8 7a ff ff ff       	call   80104ff3 <popcli>
}
80105079:	89 d8                	mov    %ebx,%eax
8010507b:	83 c4 04             	add    $0x4,%esp
8010507e:	5b                   	pop    %ebx
8010507f:	5d                   	pop    %ebp
80105080:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105081:	8b 5b 08             	mov    0x8(%ebx),%ebx
80105084:	e8 80 e7 ff ff       	call   80103809 <mycpu>
80105089:	39 c3                	cmp    %eax,%ebx
8010508b:	74 07                	je     80105094 <holding+0x3d>
8010508d:	bb 00 00 00 00       	mov    $0x0,%ebx
80105092:	eb e0                	jmp    80105074 <holding+0x1d>
80105094:	bb 01 00 00 00       	mov    $0x1,%ebx
80105099:	eb d9                	jmp    80105074 <holding+0x1d>

8010509b <acquire>:
{
8010509b:	f3 0f 1e fb          	endbr32 
8010509f:	55                   	push   %ebp
801050a0:	89 e5                	mov    %esp,%ebp
801050a2:	53                   	push   %ebx
801050a3:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801050a6:	e8 07 ff ff ff       	call   80104fb2 <pushcli>
  if(holding(lk))
801050ab:	83 ec 0c             	sub    $0xc,%esp
801050ae:	ff 75 08             	pushl  0x8(%ebp)
801050b1:	e8 a1 ff ff ff       	call   80105057 <holding>
801050b6:	83 c4 10             	add    $0x10,%esp
801050b9:	85 c0                	test   %eax,%eax
801050bb:	75 3a                	jne    801050f7 <acquire+0x5c>
  while(xchg(&lk->locked, 1) != 0)
801050bd:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
801050c0:	b8 01 00 00 00       	mov    $0x1,%eax
801050c5:	f0 87 02             	lock xchg %eax,(%edx)
801050c8:	85 c0                	test   %eax,%eax
801050ca:	75 f1                	jne    801050bd <acquire+0x22>
  __sync_synchronize();
801050cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801050d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050d4:	e8 30 e7 ff ff       	call   80103809 <mycpu>
801050d9:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801050dc:	8b 45 08             	mov    0x8(%ebp),%eax
801050df:	83 c0 0c             	add    $0xc,%eax
801050e2:	83 ec 08             	sub    $0x8,%esp
801050e5:	50                   	push   %eax
801050e6:	8d 45 08             	lea    0x8(%ebp),%eax
801050e9:	50                   	push   %eax
801050ea:	e8 7b fe ff ff       	call   80104f6a <getcallerpcs>
}
801050ef:	83 c4 10             	add    $0x10,%esp
801050f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
    panic("acquire");
801050f7:	83 ec 0c             	sub    $0xc,%esp
801050fa:	68 7d 89 10 80       	push   $0x8010897d
801050ff:	e8 58 b2 ff ff       	call   8010035c <panic>

80105104 <release>:
{
80105104:	f3 0f 1e fb          	endbr32 
80105108:	55                   	push   %ebp
80105109:	89 e5                	mov    %esp,%ebp
8010510b:	53                   	push   %ebx
8010510c:	83 ec 10             	sub    $0x10,%esp
8010510f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80105112:	53                   	push   %ebx
80105113:	e8 3f ff ff ff       	call   80105057 <holding>
80105118:	83 c4 10             	add    $0x10,%esp
8010511b:	85 c0                	test   %eax,%eax
8010511d:	74 23                	je     80105142 <release+0x3e>
  lk->pcs[0] = 0;
8010511f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105126:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010512d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105132:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80105138:	e8 b6 fe ff ff       	call   80104ff3 <popcli>
}
8010513d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105140:	c9                   	leave  
80105141:	c3                   	ret    
    panic("release");
80105142:	83 ec 0c             	sub    $0xc,%esp
80105145:	68 85 89 10 80       	push   $0x80108985
8010514a:	e8 0d b2 ff ff       	call   8010035c <panic>

8010514f <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010514f:	f3 0f 1e fb          	endbr32 
80105153:	55                   	push   %ebp
80105154:	89 e5                	mov    %esp,%ebp
80105156:	57                   	push   %edi
80105157:	53                   	push   %ebx
80105158:	8b 55 08             	mov    0x8(%ebp),%edx
8010515b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010515e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80105161:	f6 c2 03             	test   $0x3,%dl
80105164:	75 25                	jne    8010518b <memset+0x3c>
80105166:	f6 c1 03             	test   $0x3,%cl
80105169:	75 20                	jne    8010518b <memset+0x3c>
    c &= 0xFF;
8010516b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010516e:	c1 e9 02             	shr    $0x2,%ecx
80105171:	c1 e0 18             	shl    $0x18,%eax
80105174:	89 fb                	mov    %edi,%ebx
80105176:	c1 e3 10             	shl    $0x10,%ebx
80105179:	09 d8                	or     %ebx,%eax
8010517b:	89 fb                	mov    %edi,%ebx
8010517d:	c1 e3 08             	shl    $0x8,%ebx
80105180:	09 d8                	or     %ebx,%eax
80105182:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105184:	89 d7                	mov    %edx,%edi
80105186:	fc                   	cld    
80105187:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105189:	eb 05                	jmp    80105190 <memset+0x41>
  asm volatile("cld; rep stosb" :
8010518b:	89 d7                	mov    %edx,%edi
8010518d:	fc                   	cld    
8010518e:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105190:	89 d0                	mov    %edx,%eax
80105192:	5b                   	pop    %ebx
80105193:	5f                   	pop    %edi
80105194:	5d                   	pop    %ebp
80105195:	c3                   	ret    

80105196 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105196:	f3 0f 1e fb          	endbr32 
8010519a:	55                   	push   %ebp
8010519b:	89 e5                	mov    %esp,%ebp
8010519d:	56                   	push   %esi
8010519e:	53                   	push   %ebx
8010519f:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801051a5:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801051a8:	8d 70 ff             	lea    -0x1(%eax),%esi
801051ab:	85 c0                	test   %eax,%eax
801051ad:	74 1c                	je     801051cb <memcmp+0x35>
    if(*s1 != *s2)
801051af:	0f b6 01             	movzbl (%ecx),%eax
801051b2:	0f b6 1a             	movzbl (%edx),%ebx
801051b5:	38 d8                	cmp    %bl,%al
801051b7:	75 0a                	jne    801051c3 <memcmp+0x2d>
      return *s1 - *s2;
    s1++, s2++;
801051b9:	83 c1 01             	add    $0x1,%ecx
801051bc:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801051bf:	89 f0                	mov    %esi,%eax
801051c1:	eb e5                	jmp    801051a8 <memcmp+0x12>
      return *s1 - *s2;
801051c3:	0f b6 c0             	movzbl %al,%eax
801051c6:	0f b6 db             	movzbl %bl,%ebx
801051c9:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801051cb:	5b                   	pop    %ebx
801051cc:	5e                   	pop    %esi
801051cd:	5d                   	pop    %ebp
801051ce:	c3                   	ret    

801051cf <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801051cf:	f3 0f 1e fb          	endbr32 
801051d3:	55                   	push   %ebp
801051d4:	89 e5                	mov    %esp,%ebp
801051d6:	56                   	push   %esi
801051d7:	53                   	push   %ebx
801051d8:	8b 75 08             	mov    0x8(%ebp),%esi
801051db:	8b 55 0c             	mov    0xc(%ebp),%edx
801051de:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801051e1:	39 f2                	cmp    %esi,%edx
801051e3:	73 3a                	jae    8010521f <memmove+0x50>
801051e5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801051e8:	39 f1                	cmp    %esi,%ecx
801051ea:	76 37                	jbe    80105223 <memmove+0x54>
    s += n;
    d += n;
801051ec:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
801051ef:	8d 58 ff             	lea    -0x1(%eax),%ebx
801051f2:	85 c0                	test   %eax,%eax
801051f4:	74 23                	je     80105219 <memmove+0x4a>
      *--d = *--s;
801051f6:	83 e9 01             	sub    $0x1,%ecx
801051f9:	83 ea 01             	sub    $0x1,%edx
801051fc:	0f b6 01             	movzbl (%ecx),%eax
801051ff:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80105201:	89 d8                	mov    %ebx,%eax
80105203:	eb ea                	jmp    801051ef <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;
80105205:	0f b6 02             	movzbl (%edx),%eax
80105208:	88 01                	mov    %al,(%ecx)
8010520a:	8d 49 01             	lea    0x1(%ecx),%ecx
8010520d:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80105210:	89 d8                	mov    %ebx,%eax
80105212:	8d 58 ff             	lea    -0x1(%eax),%ebx
80105215:	85 c0                	test   %eax,%eax
80105217:	75 ec                	jne    80105205 <memmove+0x36>

  return dst;
}
80105219:	89 f0                	mov    %esi,%eax
8010521b:	5b                   	pop    %ebx
8010521c:	5e                   	pop    %esi
8010521d:	5d                   	pop    %ebp
8010521e:	c3                   	ret    
8010521f:	89 f1                	mov    %esi,%ecx
80105221:	eb ef                	jmp    80105212 <memmove+0x43>
80105223:	89 f1                	mov    %esi,%ecx
80105225:	eb eb                	jmp    80105212 <memmove+0x43>

80105227 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105227:	f3 0f 1e fb          	endbr32 
8010522b:	55                   	push   %ebp
8010522c:	89 e5                	mov    %esp,%ebp
8010522e:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105231:	ff 75 10             	pushl  0x10(%ebp)
80105234:	ff 75 0c             	pushl  0xc(%ebp)
80105237:	ff 75 08             	pushl  0x8(%ebp)
8010523a:	e8 90 ff ff ff       	call   801051cf <memmove>
}
8010523f:	c9                   	leave  
80105240:	c3                   	ret    

80105241 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105241:	f3 0f 1e fb          	endbr32 
80105245:	55                   	push   %ebp
80105246:	89 e5                	mov    %esp,%ebp
80105248:	53                   	push   %ebx
80105249:	8b 55 08             	mov    0x8(%ebp),%edx
8010524c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010524f:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105252:	eb 09                	jmp    8010525d <strncmp+0x1c>
    n--, p++, q++;
80105254:	83 e8 01             	sub    $0x1,%eax
80105257:	83 c2 01             	add    $0x1,%edx
8010525a:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010525d:	85 c0                	test   %eax,%eax
8010525f:	74 0b                	je     8010526c <strncmp+0x2b>
80105261:	0f b6 1a             	movzbl (%edx),%ebx
80105264:	84 db                	test   %bl,%bl
80105266:	74 04                	je     8010526c <strncmp+0x2b>
80105268:	3a 19                	cmp    (%ecx),%bl
8010526a:	74 e8                	je     80105254 <strncmp+0x13>
  if(n == 0)
8010526c:	85 c0                	test   %eax,%eax
8010526e:	74 0b                	je     8010527b <strncmp+0x3a>
    return 0;
  return (uchar)*p - (uchar)*q;
80105270:	0f b6 02             	movzbl (%edx),%eax
80105273:	0f b6 11             	movzbl (%ecx),%edx
80105276:	29 d0                	sub    %edx,%eax
}
80105278:	5b                   	pop    %ebx
80105279:	5d                   	pop    %ebp
8010527a:	c3                   	ret    
    return 0;
8010527b:	b8 00 00 00 00       	mov    $0x0,%eax
80105280:	eb f6                	jmp    80105278 <strncmp+0x37>

80105282 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105282:	f3 0f 1e fb          	endbr32 
80105286:	55                   	push   %ebp
80105287:	89 e5                	mov    %esp,%ebp
80105289:	57                   	push   %edi
8010528a:	56                   	push   %esi
8010528b:	53                   	push   %ebx
8010528c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010528f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105292:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105295:	89 fa                	mov    %edi,%edx
80105297:	eb 04                	jmp    8010529d <strncpy+0x1b>
80105299:	89 f1                	mov    %esi,%ecx
8010529b:	89 da                	mov    %ebx,%edx
8010529d:	89 c3                	mov    %eax,%ebx
8010529f:	83 e8 01             	sub    $0x1,%eax
801052a2:	85 db                	test   %ebx,%ebx
801052a4:	7e 1b                	jle    801052c1 <strncpy+0x3f>
801052a6:	8d 71 01             	lea    0x1(%ecx),%esi
801052a9:	8d 5a 01             	lea    0x1(%edx),%ebx
801052ac:	0f b6 09             	movzbl (%ecx),%ecx
801052af:	88 0a                	mov    %cl,(%edx)
801052b1:	84 c9                	test   %cl,%cl
801052b3:	75 e4                	jne    80105299 <strncpy+0x17>
801052b5:	89 da                	mov    %ebx,%edx
801052b7:	eb 08                	jmp    801052c1 <strncpy+0x3f>
    ;
  while(n-- > 0)
    *s++ = 0;
801052b9:	c6 02 00             	movb   $0x0,(%edx)
  while(n-- > 0)
801052bc:	89 c8                	mov    %ecx,%eax
    *s++ = 0;
801052be:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
801052c1:	8d 48 ff             	lea    -0x1(%eax),%ecx
801052c4:	85 c0                	test   %eax,%eax
801052c6:	7f f1                	jg     801052b9 <strncpy+0x37>
  return os;
}
801052c8:	89 f8                	mov    %edi,%eax
801052ca:	5b                   	pop    %ebx
801052cb:	5e                   	pop    %esi
801052cc:	5f                   	pop    %edi
801052cd:	5d                   	pop    %ebp
801052ce:	c3                   	ret    

801052cf <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801052cf:	f3 0f 1e fb          	endbr32 
801052d3:	55                   	push   %ebp
801052d4:	89 e5                	mov    %esp,%ebp
801052d6:	57                   	push   %edi
801052d7:	56                   	push   %esi
801052d8:	53                   	push   %ebx
801052d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801052dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801052df:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801052e2:	85 c0                	test   %eax,%eax
801052e4:	7e 23                	jle    80105309 <safestrcpy+0x3a>
801052e6:	89 fa                	mov    %edi,%edx
801052e8:	eb 04                	jmp    801052ee <safestrcpy+0x1f>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801052ea:	89 f1                	mov    %esi,%ecx
801052ec:	89 da                	mov    %ebx,%edx
801052ee:	83 e8 01             	sub    $0x1,%eax
801052f1:	85 c0                	test   %eax,%eax
801052f3:	7e 11                	jle    80105306 <safestrcpy+0x37>
801052f5:	8d 71 01             	lea    0x1(%ecx),%esi
801052f8:	8d 5a 01             	lea    0x1(%edx),%ebx
801052fb:	0f b6 09             	movzbl (%ecx),%ecx
801052fe:	88 0a                	mov    %cl,(%edx)
80105300:	84 c9                	test   %cl,%cl
80105302:	75 e6                	jne    801052ea <safestrcpy+0x1b>
80105304:	89 da                	mov    %ebx,%edx
    ;
  *s = 0;
80105306:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105309:	89 f8                	mov    %edi,%eax
8010530b:	5b                   	pop    %ebx
8010530c:	5e                   	pop    %esi
8010530d:	5f                   	pop    %edi
8010530e:	5d                   	pop    %ebp
8010530f:	c3                   	ret    

80105310 <strlen>:

int
strlen(const char *s)
{
80105310:	f3 0f 1e fb          	endbr32 
80105314:	55                   	push   %ebp
80105315:	89 e5                	mov    %esp,%ebp
80105317:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
8010531a:	b8 00 00 00 00       	mov    $0x0,%eax
8010531f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105323:	74 05                	je     8010532a <strlen+0x1a>
80105325:	83 c0 01             	add    $0x1,%eax
80105328:	eb f5                	jmp    8010531f <strlen+0xf>
    ;
  return n;
}
8010532a:	5d                   	pop    %ebp
8010532b:	c3                   	ret    

8010532c <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010532c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105330:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105334:	55                   	push   %ebp
  pushl %ebx
80105335:	53                   	push   %ebx
  pushl %esi
80105336:	56                   	push   %esi
  pushl %edi
80105337:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105338:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010533a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010533c:	5f                   	pop    %edi
  popl %esi
8010533d:	5e                   	pop    %esi
  popl %ebx
8010533e:	5b                   	pop    %ebx
  popl %ebp
8010533f:	5d                   	pop    %ebp
  ret
80105340:	c3                   	ret    

80105341 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105341:	f3 0f 1e fb          	endbr32 
80105345:	55                   	push   %ebp
80105346:	89 e5                	mov    %esp,%ebp
80105348:	53                   	push   %ebx
80105349:	83 ec 04             	sub    $0x4,%esp
8010534c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010534f:	e8 34 e5 ff ff       	call   80103888 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105354:	8b 00                	mov    (%eax),%eax
80105356:	39 d8                	cmp    %ebx,%eax
80105358:	76 19                	jbe    80105373 <fetchint+0x32>
8010535a:	8d 53 04             	lea    0x4(%ebx),%edx
8010535d:	39 d0                	cmp    %edx,%eax
8010535f:	72 19                	jb     8010537a <fetchint+0x39>
    return -1;
  *ip = *(int*)(addr);
80105361:	8b 13                	mov    (%ebx),%edx
80105363:	8b 45 0c             	mov    0xc(%ebp),%eax
80105366:	89 10                	mov    %edx,(%eax)
  return 0;
80105368:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010536d:	83 c4 04             	add    $0x4,%esp
80105370:	5b                   	pop    %ebx
80105371:	5d                   	pop    %ebp
80105372:	c3                   	ret    
    return -1;
80105373:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105378:	eb f3                	jmp    8010536d <fetchint+0x2c>
8010537a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010537f:	eb ec                	jmp    8010536d <fetchint+0x2c>

80105381 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105381:	f3 0f 1e fb          	endbr32 
80105385:	55                   	push   %ebp
80105386:	89 e5                	mov    %esp,%ebp
80105388:	53                   	push   %ebx
80105389:	83 ec 04             	sub    $0x4,%esp
8010538c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010538f:	e8 f4 e4 ff ff       	call   80103888 <myproc>

  if(addr >= curproc->sz)
80105394:	39 18                	cmp    %ebx,(%eax)
80105396:	76 26                	jbe    801053be <fetchstr+0x3d>
    return -1;
  *pp = (char*)addr;
80105398:	8b 55 0c             	mov    0xc(%ebp),%edx
8010539b:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010539d:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010539f:	89 d8                	mov    %ebx,%eax
801053a1:	39 d0                	cmp    %edx,%eax
801053a3:	73 0e                	jae    801053b3 <fetchstr+0x32>
    if(*s == 0)
801053a5:	80 38 00             	cmpb   $0x0,(%eax)
801053a8:	74 05                	je     801053af <fetchstr+0x2e>
  for(s = *pp; s < ep; s++){
801053aa:	83 c0 01             	add    $0x1,%eax
801053ad:	eb f2                	jmp    801053a1 <fetchstr+0x20>
      return s - *pp;
801053af:	29 d8                	sub    %ebx,%eax
801053b1:	eb 05                	jmp    801053b8 <fetchstr+0x37>
  }
  return -1;
801053b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053b8:	83 c4 04             	add    $0x4,%esp
801053bb:	5b                   	pop    %ebx
801053bc:	5d                   	pop    %ebp
801053bd:	c3                   	ret    
    return -1;
801053be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c3:	eb f3                	jmp    801053b8 <fetchstr+0x37>

801053c5 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801053c5:	f3 0f 1e fb          	endbr32 
801053c9:	55                   	push   %ebp
801053ca:	89 e5                	mov    %esp,%ebp
801053cc:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053cf:	e8 b4 e4 ff ff       	call   80103888 <myproc>
801053d4:	8b 50 18             	mov    0x18(%eax),%edx
801053d7:	8b 45 08             	mov    0x8(%ebp),%eax
801053da:	c1 e0 02             	shl    $0x2,%eax
801053dd:	03 42 44             	add    0x44(%edx),%eax
801053e0:	83 ec 08             	sub    $0x8,%esp
801053e3:	ff 75 0c             	pushl  0xc(%ebp)
801053e6:	83 c0 04             	add    $0x4,%eax
801053e9:	50                   	push   %eax
801053ea:	e8 52 ff ff ff       	call   80105341 <fetchint>
}
801053ef:	c9                   	leave  
801053f0:	c3                   	ret    

801053f1 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801053f1:	f3 0f 1e fb          	endbr32 
801053f5:	55                   	push   %ebp
801053f6:	89 e5                	mov    %esp,%ebp
801053f8:	56                   	push   %esi
801053f9:	53                   	push   %ebx
801053fa:	83 ec 10             	sub    $0x10,%esp
801053fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80105400:	e8 83 e4 ff ff       	call   80103888 <myproc>
80105405:	89 c6                	mov    %eax,%esi

  if(argint(n, &i) < 0)
80105407:	83 ec 08             	sub    $0x8,%esp
8010540a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540d:	50                   	push   %eax
8010540e:	ff 75 08             	pushl  0x8(%ebp)
80105411:	e8 af ff ff ff       	call   801053c5 <argint>
80105416:	83 c4 10             	add    $0x10,%esp
80105419:	85 c0                	test   %eax,%eax
8010541b:	78 24                	js     80105441 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010541d:	85 db                	test   %ebx,%ebx
8010541f:	78 27                	js     80105448 <argptr+0x57>
80105421:	8b 16                	mov    (%esi),%edx
80105423:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105426:	39 c2                	cmp    %eax,%edx
80105428:	76 25                	jbe    8010544f <argptr+0x5e>
8010542a:	01 c3                	add    %eax,%ebx
8010542c:	39 da                	cmp    %ebx,%edx
8010542e:	72 26                	jb     80105456 <argptr+0x65>
    return -1;
  *pp = (char*)i;
80105430:	8b 55 0c             	mov    0xc(%ebp),%edx
80105433:	89 02                	mov    %eax,(%edx)
  return 0;
80105435:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010543a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010543d:	5b                   	pop    %ebx
8010543e:	5e                   	pop    %esi
8010543f:	5d                   	pop    %ebp
80105440:	c3                   	ret    
    return -1;
80105441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105446:	eb f2                	jmp    8010543a <argptr+0x49>
    return -1;
80105448:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010544d:	eb eb                	jmp    8010543a <argptr+0x49>
8010544f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105454:	eb e4                	jmp    8010543a <argptr+0x49>
80105456:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545b:	eb dd                	jmp    8010543a <argptr+0x49>

8010545d <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010545d:	f3 0f 1e fb          	endbr32 
80105461:	55                   	push   %ebp
80105462:	89 e5                	mov    %esp,%ebp
80105464:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105467:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010546a:	50                   	push   %eax
8010546b:	ff 75 08             	pushl  0x8(%ebp)
8010546e:	e8 52 ff ff ff       	call   801053c5 <argint>
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	85 c0                	test   %eax,%eax
80105478:	78 13                	js     8010548d <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010547a:	83 ec 08             	sub    $0x8,%esp
8010547d:	ff 75 0c             	pushl  0xc(%ebp)
80105480:	ff 75 f4             	pushl  -0xc(%ebp)
80105483:	e8 f9 fe ff ff       	call   80105381 <fetchstr>
80105488:	83 c4 10             	add    $0x10,%esp
}
8010548b:	c9                   	leave  
8010548c:	c3                   	ret    
    return -1;
8010548d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105492:	eb f7                	jmp    8010548b <argstr+0x2e>

80105494 <syscall>:
};
#endif // PRINT_SYSCALLS

void
syscall(void)
{
80105494:	f3 0f 1e fb          	endbr32 
80105498:	55                   	push   %ebp
80105499:	89 e5                	mov    %esp,%ebp
8010549b:	53                   	push   %ebx
8010549c:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010549f:	e8 e4 e3 ff ff       	call   80103888 <myproc>
801054a4:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801054a6:	8b 40 18             	mov    0x18(%eax),%eax
801054a9:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801054ac:	8d 50 ff             	lea    -0x1(%eax),%edx
801054af:	83 fa 1e             	cmp    $0x1e,%edx
801054b2:	77 17                	ja     801054cb <syscall+0x37>
801054b4:	8b 14 85 c0 89 10 80 	mov    -0x7fef7640(,%eax,4),%edx
801054bb:	85 d2                	test   %edx,%edx
801054bd:	74 0c                	je     801054cb <syscall+0x37>
    curproc->tf->eax = syscalls[num]();
801054bf:	ff d2                	call   *%edx
801054c1:	89 c2                	mov    %eax,%edx
801054c3:	8b 43 18             	mov    0x18(%ebx),%eax
801054c6:	89 50 1c             	mov    %edx,0x1c(%eax)
801054c9:	eb 1f                	jmp    801054ea <syscall+0x56>
#ifdef PRINT_SYSCALLS
  cprintf("%s -> %d\n", syscallnames[num], curproc->tf->eax);
#endif //PRINT_SYSCALLS
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801054cb:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
801054ce:	50                   	push   %eax
801054cf:	52                   	push   %edx
801054d0:	ff 73 10             	pushl  0x10(%ebx)
801054d3:	68 8d 89 10 80       	push   $0x8010898d
801054d8:	e8 4c b1 ff ff       	call   80100629 <cprintf>
    curproc->tf->eax = -1;
801054dd:	8b 43 18             	mov    0x18(%ebx),%eax
801054e0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801054e7:	83 c4 10             	add    $0x10,%esp
  }
}
801054ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054ed:	c9                   	leave  
801054ee:	c3                   	ret    

801054ef <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801054ef:	55                   	push   %ebp
801054f0:	89 e5                	mov    %esp,%ebp
801054f2:	56                   	push   %esi
801054f3:	53                   	push   %ebx
801054f4:	83 ec 18             	sub    $0x18,%esp
801054f7:	89 d6                	mov    %edx,%esi
801054f9:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801054fb:	8d 55 f4             	lea    -0xc(%ebp),%edx
801054fe:	52                   	push   %edx
801054ff:	50                   	push   %eax
80105500:	e8 c0 fe ff ff       	call   801053c5 <argint>
80105505:	83 c4 10             	add    $0x10,%esp
80105508:	85 c0                	test   %eax,%eax
8010550a:	78 35                	js     80105541 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010550c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105510:	77 28                	ja     8010553a <argfd+0x4b>
80105512:	e8 71 e3 ff ff       	call   80103888 <myproc>
80105517:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010551a:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
8010551e:	85 c0                	test   %eax,%eax
80105520:	74 18                	je     8010553a <argfd+0x4b>
    return -1;
  if(pfd)
80105522:	85 f6                	test   %esi,%esi
80105524:	74 02                	je     80105528 <argfd+0x39>
    *pfd = fd;
80105526:	89 16                	mov    %edx,(%esi)
  if(pf)
80105528:	85 db                	test   %ebx,%ebx
8010552a:	74 1c                	je     80105548 <argfd+0x59>
    *pf = f;
8010552c:	89 03                	mov    %eax,(%ebx)
  return 0;
8010552e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105533:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105536:	5b                   	pop    %ebx
80105537:	5e                   	pop    %esi
80105538:	5d                   	pop    %ebp
80105539:	c3                   	ret    
    return -1;
8010553a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553f:	eb f2                	jmp    80105533 <argfd+0x44>
    return -1;
80105541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105546:	eb eb                	jmp    80105533 <argfd+0x44>
  return 0;
80105548:	b8 00 00 00 00       	mov    $0x0,%eax
8010554d:	eb e4                	jmp    80105533 <argfd+0x44>

8010554f <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010554f:	55                   	push   %ebp
80105550:	89 e5                	mov    %esp,%ebp
80105552:	53                   	push   %ebx
80105553:	83 ec 04             	sub    $0x4,%esp
80105556:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80105558:	e8 2b e3 ff ff       	call   80103888 <myproc>
8010555d:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
8010555f:	b8 00 00 00 00       	mov    $0x0,%eax
80105564:	83 f8 0f             	cmp    $0xf,%eax
80105567:	7f 12                	jg     8010557b <fdalloc+0x2c>
    if(curproc->ofile[fd] == 0){
80105569:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
8010556e:	74 05                	je     80105575 <fdalloc+0x26>
  for(fd = 0; fd < NOFILE; fd++){
80105570:	83 c0 01             	add    $0x1,%eax
80105573:	eb ef                	jmp    80105564 <fdalloc+0x15>
      curproc->ofile[fd] = f;
80105575:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
80105579:	eb 05                	jmp    80105580 <fdalloc+0x31>
    }
  }
  return -1;
8010557b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105580:	83 c4 04             	add    $0x4,%esp
80105583:	5b                   	pop    %ebx
80105584:	5d                   	pop    %ebp
80105585:	c3                   	ret    

80105586 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105586:	55                   	push   %ebp
80105587:	89 e5                	mov    %esp,%ebp
80105589:	56                   	push   %esi
8010558a:	53                   	push   %ebx
8010558b:	83 ec 10             	sub    $0x10,%esp
8010558e:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105590:	b8 20 00 00 00       	mov    $0x20,%eax
80105595:	89 c6                	mov    %eax,%esi
80105597:	39 43 58             	cmp    %eax,0x58(%ebx)
8010559a:	76 2e                	jbe    801055ca <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010559c:	6a 10                	push   $0x10
8010559e:	50                   	push   %eax
8010559f:	8d 45 e8             	lea    -0x18(%ebp),%eax
801055a2:	50                   	push   %eax
801055a3:	53                   	push   %ebx
801055a4:	e8 d8 c2 ff ff       	call   80101881 <readi>
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	83 f8 10             	cmp    $0x10,%eax
801055af:	75 0c                	jne    801055bd <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
801055b1:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
801055b6:	75 1e                	jne    801055d6 <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801055b8:	8d 46 10             	lea    0x10(%esi),%eax
801055bb:	eb d8                	jmp    80105595 <isdirempty+0xf>
      panic("isdirempty: readi");
801055bd:	83 ec 0c             	sub    $0xc,%esp
801055c0:	68 40 8a 10 80       	push   $0x80108a40
801055c5:	e8 92 ad ff ff       	call   8010035c <panic>
      return 0;
  }
  return 1;
801055ca:	b8 01 00 00 00       	mov    $0x1,%eax
}
801055cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055d2:	5b                   	pop    %ebx
801055d3:	5e                   	pop    %esi
801055d4:	5d                   	pop    %ebp
801055d5:	c3                   	ret    
      return 0;
801055d6:	b8 00 00 00 00       	mov    $0x0,%eax
801055db:	eb f2                	jmp    801055cf <isdirempty+0x49>

801055dd <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801055dd:	55                   	push   %ebp
801055de:	89 e5                	mov    %esp,%ebp
801055e0:	57                   	push   %edi
801055e1:	56                   	push   %esi
801055e2:	53                   	push   %ebx
801055e3:	83 ec 44             	sub    $0x44,%esp
801055e6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801055e9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801055ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801055ef:	8d 55 d6             	lea    -0x2a(%ebp),%edx
801055f2:	52                   	push   %edx
801055f3:	50                   	push   %eax
801055f4:	e8 23 c7 ff ff       	call   80101d1c <nameiparent>
801055f9:	89 c6                	mov    %eax,%esi
801055fb:	83 c4 10             	add    $0x10,%esp
801055fe:	85 c0                	test   %eax,%eax
80105600:	0f 84 35 01 00 00    	je     8010573b <create+0x15e>
    return 0;
  ilock(dp);
80105606:	83 ec 0c             	sub    $0xc,%esp
80105609:	50                   	push   %eax
8010560a:	e8 6c c0 ff ff       	call   8010167b <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010560f:	83 c4 0c             	add    $0xc,%esp
80105612:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105615:	50                   	push   %eax
80105616:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80105619:	50                   	push   %eax
8010561a:	56                   	push   %esi
8010561b:	e8 aa c4 ff ff       	call   80101aca <dirlookup>
80105620:	89 c3                	mov    %eax,%ebx
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	74 3d                	je     80105666 <create+0x89>
    iunlockput(dp);
80105629:	83 ec 0c             	sub    $0xc,%esp
8010562c:	56                   	push   %esi
8010562d:	e8 fc c1 ff ff       	call   8010182e <iunlockput>
    ilock(ip);
80105632:	89 1c 24             	mov    %ebx,(%esp)
80105635:	e8 41 c0 ff ff       	call   8010167b <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105642:	75 07                	jne    8010564b <create+0x6e>
80105644:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80105649:	74 11                	je     8010565c <create+0x7f>
      return ip;
    iunlockput(ip);
8010564b:	83 ec 0c             	sub    $0xc,%esp
8010564e:	53                   	push   %ebx
8010564f:	e8 da c1 ff ff       	call   8010182e <iunlockput>
    return 0;
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010565c:	89 d8                	mov    %ebx,%eax
8010565e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105661:	5b                   	pop    %ebx
80105662:	5e                   	pop    %esi
80105663:	5f                   	pop    %edi
80105664:	5d                   	pop    %ebp
80105665:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80105666:	83 ec 08             	sub    $0x8,%esp
80105669:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
8010566d:	50                   	push   %eax
8010566e:	ff 36                	pushl  (%esi)
80105670:	e8 f7 bd ff ff       	call   8010146c <ialloc>
80105675:	89 c3                	mov    %eax,%ebx
80105677:	83 c4 10             	add    $0x10,%esp
8010567a:	85 c0                	test   %eax,%eax
8010567c:	74 52                	je     801056d0 <create+0xf3>
  ilock(ip);
8010567e:	83 ec 0c             	sub    $0xc,%esp
80105681:	50                   	push   %eax
80105682:	e8 f4 bf ff ff       	call   8010167b <ilock>
  ip->major = major;
80105687:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
8010568b:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010568f:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
80105693:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
80105699:	89 1c 24             	mov    %ebx,(%esp)
8010569c:	e8 71 be ff ff       	call   80101512 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801056a1:	83 c4 10             	add    $0x10,%esp
801056a4:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801056a9:	74 32                	je     801056dd <create+0x100>
  if(dirlink(dp, name, ip->inum) < 0)
801056ab:	83 ec 04             	sub    $0x4,%esp
801056ae:	ff 73 04             	pushl  0x4(%ebx)
801056b1:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801056b4:	50                   	push   %eax
801056b5:	56                   	push   %esi
801056b6:	e8 90 c5 ff ff       	call   80101c4b <dirlink>
801056bb:	83 c4 10             	add    $0x10,%esp
801056be:	85 c0                	test   %eax,%eax
801056c0:	78 6c                	js     8010572e <create+0x151>
  iunlockput(dp);
801056c2:	83 ec 0c             	sub    $0xc,%esp
801056c5:	56                   	push   %esi
801056c6:	e8 63 c1 ff ff       	call   8010182e <iunlockput>
  return ip;
801056cb:	83 c4 10             	add    $0x10,%esp
801056ce:	eb 8c                	jmp    8010565c <create+0x7f>
    panic("create: ialloc");
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	68 52 8a 10 80       	push   $0x80108a52
801056d8:	e8 7f ac ff ff       	call   8010035c <panic>
    dp->nlink++;  // for ".."
801056dd:	0f b7 46 56          	movzwl 0x56(%esi),%eax
801056e1:	83 c0 01             	add    $0x1,%eax
801056e4:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801056e8:	83 ec 0c             	sub    $0xc,%esp
801056eb:	56                   	push   %esi
801056ec:	e8 21 be ff ff       	call   80101512 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801056f1:	83 c4 0c             	add    $0xc,%esp
801056f4:	ff 73 04             	pushl  0x4(%ebx)
801056f7:	68 62 8a 10 80       	push   $0x80108a62
801056fc:	53                   	push   %ebx
801056fd:	e8 49 c5 ff ff       	call   80101c4b <dirlink>
80105702:	83 c4 10             	add    $0x10,%esp
80105705:	85 c0                	test   %eax,%eax
80105707:	78 18                	js     80105721 <create+0x144>
80105709:	83 ec 04             	sub    $0x4,%esp
8010570c:	ff 76 04             	pushl  0x4(%esi)
8010570f:	68 61 8a 10 80       	push   $0x80108a61
80105714:	53                   	push   %ebx
80105715:	e8 31 c5 ff ff       	call   80101c4b <dirlink>
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	85 c0                	test   %eax,%eax
8010571f:	79 8a                	jns    801056ab <create+0xce>
      panic("create dots");
80105721:	83 ec 0c             	sub    $0xc,%esp
80105724:	68 64 8a 10 80       	push   $0x80108a64
80105729:	e8 2e ac ff ff       	call   8010035c <panic>
    panic("create: dirlink");
8010572e:	83 ec 0c             	sub    $0xc,%esp
80105731:	68 70 8a 10 80       	push   $0x80108a70
80105736:	e8 21 ac ff ff       	call   8010035c <panic>
    return 0;
8010573b:	89 c3                	mov    %eax,%ebx
8010573d:	e9 1a ff ff ff       	jmp    8010565c <create+0x7f>

80105742 <sys_dup>:
{
80105742:	f3 0f 1e fb          	endbr32 
80105746:	55                   	push   %ebp
80105747:	89 e5                	mov    %esp,%ebp
80105749:	53                   	push   %ebx
8010574a:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
8010574d:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80105750:	ba 00 00 00 00       	mov    $0x0,%edx
80105755:	b8 00 00 00 00       	mov    $0x0,%eax
8010575a:	e8 90 fd ff ff       	call   801054ef <argfd>
8010575f:	85 c0                	test   %eax,%eax
80105761:	78 23                	js     80105786 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
80105763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105766:	e8 e4 fd ff ff       	call   8010554f <fdalloc>
8010576b:	89 c3                	mov    %eax,%ebx
8010576d:	85 c0                	test   %eax,%eax
8010576f:	78 1c                	js     8010578d <sys_dup+0x4b>
  filedup(f);
80105771:	83 ec 0c             	sub    $0xc,%esp
80105774:	ff 75 f4             	pushl  -0xc(%ebp)
80105777:	e8 e3 b5 ff ff       	call   80100d5f <filedup>
  return fd;
8010577c:	83 c4 10             	add    $0x10,%esp
}
8010577f:	89 d8                	mov    %ebx,%eax
80105781:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105784:	c9                   	leave  
80105785:	c3                   	ret    
    return -1;
80105786:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010578b:	eb f2                	jmp    8010577f <sys_dup+0x3d>
    return -1;
8010578d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105792:	eb eb                	jmp    8010577f <sys_dup+0x3d>

80105794 <sys_read>:
{
80105794:	f3 0f 1e fb          	endbr32 
80105798:	55                   	push   %ebp
80105799:	89 e5                	mov    %esp,%ebp
8010579b:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010579e:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801057a1:	ba 00 00 00 00       	mov    $0x0,%edx
801057a6:	b8 00 00 00 00       	mov    $0x0,%eax
801057ab:	e8 3f fd ff ff       	call   801054ef <argfd>
801057b0:	85 c0                	test   %eax,%eax
801057b2:	78 43                	js     801057f7 <sys_read+0x63>
801057b4:	83 ec 08             	sub    $0x8,%esp
801057b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057ba:	50                   	push   %eax
801057bb:	6a 02                	push   $0x2
801057bd:	e8 03 fc ff ff       	call   801053c5 <argint>
801057c2:	83 c4 10             	add    $0x10,%esp
801057c5:	85 c0                	test   %eax,%eax
801057c7:	78 2e                	js     801057f7 <sys_read+0x63>
801057c9:	83 ec 04             	sub    $0x4,%esp
801057cc:	ff 75 f0             	pushl  -0x10(%ebp)
801057cf:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057d2:	50                   	push   %eax
801057d3:	6a 01                	push   $0x1
801057d5:	e8 17 fc ff ff       	call   801053f1 <argptr>
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	85 c0                	test   %eax,%eax
801057df:	78 16                	js     801057f7 <sys_read+0x63>
  return fileread(f, p, n);
801057e1:	83 ec 04             	sub    $0x4,%esp
801057e4:	ff 75 f0             	pushl  -0x10(%ebp)
801057e7:	ff 75 ec             	pushl  -0x14(%ebp)
801057ea:	ff 75 f4             	pushl  -0xc(%ebp)
801057ed:	e8 bf b6 ff ff       	call   80100eb1 <fileread>
801057f2:	83 c4 10             	add    $0x10,%esp
}
801057f5:	c9                   	leave  
801057f6:	c3                   	ret    
    return -1;
801057f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fc:	eb f7                	jmp    801057f5 <sys_read+0x61>

801057fe <sys_write>:
{
801057fe:	f3 0f 1e fb          	endbr32 
80105802:	55                   	push   %ebp
80105803:	89 e5                	mov    %esp,%ebp
80105805:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105808:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010580b:	ba 00 00 00 00       	mov    $0x0,%edx
80105810:	b8 00 00 00 00       	mov    $0x0,%eax
80105815:	e8 d5 fc ff ff       	call   801054ef <argfd>
8010581a:	85 c0                	test   %eax,%eax
8010581c:	78 43                	js     80105861 <sys_write+0x63>
8010581e:	83 ec 08             	sub    $0x8,%esp
80105821:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105824:	50                   	push   %eax
80105825:	6a 02                	push   $0x2
80105827:	e8 99 fb ff ff       	call   801053c5 <argint>
8010582c:	83 c4 10             	add    $0x10,%esp
8010582f:	85 c0                	test   %eax,%eax
80105831:	78 2e                	js     80105861 <sys_write+0x63>
80105833:	83 ec 04             	sub    $0x4,%esp
80105836:	ff 75 f0             	pushl  -0x10(%ebp)
80105839:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010583c:	50                   	push   %eax
8010583d:	6a 01                	push   $0x1
8010583f:	e8 ad fb ff ff       	call   801053f1 <argptr>
80105844:	83 c4 10             	add    $0x10,%esp
80105847:	85 c0                	test   %eax,%eax
80105849:	78 16                	js     80105861 <sys_write+0x63>
  return filewrite(f, p, n);
8010584b:	83 ec 04             	sub    $0x4,%esp
8010584e:	ff 75 f0             	pushl  -0x10(%ebp)
80105851:	ff 75 ec             	pushl  -0x14(%ebp)
80105854:	ff 75 f4             	pushl  -0xc(%ebp)
80105857:	e8 de b6 ff ff       	call   80100f3a <filewrite>
8010585c:	83 c4 10             	add    $0x10,%esp
}
8010585f:	c9                   	leave  
80105860:	c3                   	ret    
    return -1;
80105861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105866:	eb f7                	jmp    8010585f <sys_write+0x61>

80105868 <sys_close>:
{
80105868:	f3 0f 1e fb          	endbr32 
8010586c:	55                   	push   %ebp
8010586d:	89 e5                	mov    %esp,%ebp
8010586f:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105872:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80105875:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105878:	b8 00 00 00 00       	mov    $0x0,%eax
8010587d:	e8 6d fc ff ff       	call   801054ef <argfd>
80105882:	85 c0                	test   %eax,%eax
80105884:	78 25                	js     801058ab <sys_close+0x43>
  myproc()->ofile[fd] = 0;
80105886:	e8 fd df ff ff       	call   80103888 <myproc>
8010588b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010588e:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105895:	00 
  fileclose(f);
80105896:	83 ec 0c             	sub    $0xc,%esp
80105899:	ff 75 f0             	pushl  -0x10(%ebp)
8010589c:	e8 07 b5 ff ff       	call   80100da8 <fileclose>
  return 0;
801058a1:	83 c4 10             	add    $0x10,%esp
801058a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058a9:	c9                   	leave  
801058aa:	c3                   	ret    
    return -1;
801058ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b0:	eb f7                	jmp    801058a9 <sys_close+0x41>

801058b2 <sys_fstat>:
{
801058b2:	f3 0f 1e fb          	endbr32 
801058b6:	55                   	push   %ebp
801058b7:	89 e5                	mov    %esp,%ebp
801058b9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058bc:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801058bf:	ba 00 00 00 00       	mov    $0x0,%edx
801058c4:	b8 00 00 00 00       	mov    $0x0,%eax
801058c9:	e8 21 fc ff ff       	call   801054ef <argfd>
801058ce:	85 c0                	test   %eax,%eax
801058d0:	78 2a                	js     801058fc <sys_fstat+0x4a>
801058d2:	83 ec 04             	sub    $0x4,%esp
801058d5:	6a 14                	push   $0x14
801058d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058da:	50                   	push   %eax
801058db:	6a 01                	push   $0x1
801058dd:	e8 0f fb ff ff       	call   801053f1 <argptr>
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	85 c0                	test   %eax,%eax
801058e7:	78 13                	js     801058fc <sys_fstat+0x4a>
  return filestat(f, st);
801058e9:	83 ec 08             	sub    $0x8,%esp
801058ec:	ff 75 f0             	pushl  -0x10(%ebp)
801058ef:	ff 75 f4             	pushl  -0xc(%ebp)
801058f2:	e8 6f b5 ff ff       	call   80100e66 <filestat>
801058f7:	83 c4 10             	add    $0x10,%esp
}
801058fa:	c9                   	leave  
801058fb:	c3                   	ret    
    return -1;
801058fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105901:	eb f7                	jmp    801058fa <sys_fstat+0x48>

80105903 <sys_link>:
{
80105903:	f3 0f 1e fb          	endbr32 
80105907:	55                   	push   %ebp
80105908:	89 e5                	mov    %esp,%ebp
8010590a:	56                   	push   %esi
8010590b:	53                   	push   %ebx
8010590c:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010590f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105912:	50                   	push   %eax
80105913:	6a 00                	push   $0x0
80105915:	e8 43 fb ff ff       	call   8010545d <argstr>
8010591a:	83 c4 10             	add    $0x10,%esp
8010591d:	85 c0                	test   %eax,%eax
8010591f:	0f 88 d3 00 00 00    	js     801059f8 <sys_link+0xf5>
80105925:	83 ec 08             	sub    $0x8,%esp
80105928:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010592b:	50                   	push   %eax
8010592c:	6a 01                	push   $0x1
8010592e:	e8 2a fb ff ff       	call   8010545d <argstr>
80105933:	83 c4 10             	add    $0x10,%esp
80105936:	85 c0                	test   %eax,%eax
80105938:	0f 88 ba 00 00 00    	js     801059f8 <sys_link+0xf5>
  begin_op();
8010593e:	e8 bd cf ff ff       	call   80102900 <begin_op>
  if((ip = namei(old)) == 0){
80105943:	83 ec 0c             	sub    $0xc,%esp
80105946:	ff 75 e0             	pushl  -0x20(%ebp)
80105949:	e8 b2 c3 ff ff       	call   80101d00 <namei>
8010594e:	89 c3                	mov    %eax,%ebx
80105950:	83 c4 10             	add    $0x10,%esp
80105953:	85 c0                	test   %eax,%eax
80105955:	0f 84 a4 00 00 00    	je     801059ff <sys_link+0xfc>
  ilock(ip);
8010595b:	83 ec 0c             	sub    $0xc,%esp
8010595e:	50                   	push   %eax
8010595f:	e8 17 bd ff ff       	call   8010167b <ilock>
  if(ip->type == T_DIR){
80105964:	83 c4 10             	add    $0x10,%esp
80105967:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010596c:	0f 84 99 00 00 00    	je     80105a0b <sys_link+0x108>
  ip->nlink++;
80105972:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80105976:	83 c0 01             	add    $0x1,%eax
80105979:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010597d:	83 ec 0c             	sub    $0xc,%esp
80105980:	53                   	push   %ebx
80105981:	e8 8c bb ff ff       	call   80101512 <iupdate>
  iunlock(ip);
80105986:	89 1c 24             	mov    %ebx,(%esp)
80105989:	e8 b3 bd ff ff       	call   80101741 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
8010598e:	83 c4 08             	add    $0x8,%esp
80105991:	8d 45 ea             	lea    -0x16(%ebp),%eax
80105994:	50                   	push   %eax
80105995:	ff 75 e4             	pushl  -0x1c(%ebp)
80105998:	e8 7f c3 ff ff       	call   80101d1c <nameiparent>
8010599d:	89 c6                	mov    %eax,%esi
8010599f:	83 c4 10             	add    $0x10,%esp
801059a2:	85 c0                	test   %eax,%eax
801059a4:	0f 84 85 00 00 00    	je     80105a2f <sys_link+0x12c>
  ilock(dp);
801059aa:	83 ec 0c             	sub    $0xc,%esp
801059ad:	50                   	push   %eax
801059ae:	e8 c8 bc ff ff       	call   8010167b <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059b3:	83 c4 10             	add    $0x10,%esp
801059b6:	8b 03                	mov    (%ebx),%eax
801059b8:	39 06                	cmp    %eax,(%esi)
801059ba:	75 67                	jne    80105a23 <sys_link+0x120>
801059bc:	83 ec 04             	sub    $0x4,%esp
801059bf:	ff 73 04             	pushl  0x4(%ebx)
801059c2:	8d 45 ea             	lea    -0x16(%ebp),%eax
801059c5:	50                   	push   %eax
801059c6:	56                   	push   %esi
801059c7:	e8 7f c2 ff ff       	call   80101c4b <dirlink>
801059cc:	83 c4 10             	add    $0x10,%esp
801059cf:	85 c0                	test   %eax,%eax
801059d1:	78 50                	js     80105a23 <sys_link+0x120>
  iunlockput(dp);
801059d3:	83 ec 0c             	sub    $0xc,%esp
801059d6:	56                   	push   %esi
801059d7:	e8 52 be ff ff       	call   8010182e <iunlockput>
  iput(ip);
801059dc:	89 1c 24             	mov    %ebx,(%esp)
801059df:	e8 a6 bd ff ff       	call   8010178a <iput>
  end_op();
801059e4:	e8 95 cf ff ff       	call   8010297e <end_op>
  return 0;
801059e9:	83 c4 10             	add    $0x10,%esp
801059ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059f4:	5b                   	pop    %ebx
801059f5:	5e                   	pop    %esi
801059f6:	5d                   	pop    %ebp
801059f7:	c3                   	ret    
    return -1;
801059f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fd:	eb f2                	jmp    801059f1 <sys_link+0xee>
    end_op();
801059ff:	e8 7a cf ff ff       	call   8010297e <end_op>
    return -1;
80105a04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a09:	eb e6                	jmp    801059f1 <sys_link+0xee>
    iunlockput(ip);
80105a0b:	83 ec 0c             	sub    $0xc,%esp
80105a0e:	53                   	push   %ebx
80105a0f:	e8 1a be ff ff       	call   8010182e <iunlockput>
    end_op();
80105a14:	e8 65 cf ff ff       	call   8010297e <end_op>
    return -1;
80105a19:	83 c4 10             	add    $0x10,%esp
80105a1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a21:	eb ce                	jmp    801059f1 <sys_link+0xee>
    iunlockput(dp);
80105a23:	83 ec 0c             	sub    $0xc,%esp
80105a26:	56                   	push   %esi
80105a27:	e8 02 be ff ff       	call   8010182e <iunlockput>
    goto bad;
80105a2c:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a2f:	83 ec 0c             	sub    $0xc,%esp
80105a32:	53                   	push   %ebx
80105a33:	e8 43 bc ff ff       	call   8010167b <ilock>
  ip->nlink--;
80105a38:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80105a3c:	83 e8 01             	sub    $0x1,%eax
80105a3f:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80105a43:	89 1c 24             	mov    %ebx,(%esp)
80105a46:	e8 c7 ba ff ff       	call   80101512 <iupdate>
  iunlockput(ip);
80105a4b:	89 1c 24             	mov    %ebx,(%esp)
80105a4e:	e8 db bd ff ff       	call   8010182e <iunlockput>
  end_op();
80105a53:	e8 26 cf ff ff       	call   8010297e <end_op>
  return -1;
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a60:	eb 8f                	jmp    801059f1 <sys_link+0xee>

80105a62 <sys_unlink>:
{
80105a62:	f3 0f 1e fb          	endbr32 
80105a66:	55                   	push   %ebp
80105a67:	89 e5                	mov    %esp,%ebp
80105a69:	57                   	push   %edi
80105a6a:	56                   	push   %esi
80105a6b:	53                   	push   %ebx
80105a6c:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105a6f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105a72:	50                   	push   %eax
80105a73:	6a 00                	push   $0x0
80105a75:	e8 e3 f9 ff ff       	call   8010545d <argstr>
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	85 c0                	test   %eax,%eax
80105a7f:	0f 88 83 01 00 00    	js     80105c08 <sys_unlink+0x1a6>
  begin_op();
80105a85:	e8 76 ce ff ff       	call   80102900 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105a8a:	83 ec 08             	sub    $0x8,%esp
80105a8d:	8d 45 ca             	lea    -0x36(%ebp),%eax
80105a90:	50                   	push   %eax
80105a91:	ff 75 c4             	pushl  -0x3c(%ebp)
80105a94:	e8 83 c2 ff ff       	call   80101d1c <nameiparent>
80105a99:	89 c6                	mov    %eax,%esi
80105a9b:	83 c4 10             	add    $0x10,%esp
80105a9e:	85 c0                	test   %eax,%eax
80105aa0:	0f 84 ed 00 00 00    	je     80105b93 <sys_unlink+0x131>
  ilock(dp);
80105aa6:	83 ec 0c             	sub    $0xc,%esp
80105aa9:	50                   	push   %eax
80105aaa:	e8 cc bb ff ff       	call   8010167b <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105aaf:	83 c4 08             	add    $0x8,%esp
80105ab2:	68 62 8a 10 80       	push   $0x80108a62
80105ab7:	8d 45 ca             	lea    -0x36(%ebp),%eax
80105aba:	50                   	push   %eax
80105abb:	e8 f1 bf ff ff       	call   80101ab1 <namecmp>
80105ac0:	83 c4 10             	add    $0x10,%esp
80105ac3:	85 c0                	test   %eax,%eax
80105ac5:	0f 84 fc 00 00 00    	je     80105bc7 <sys_unlink+0x165>
80105acb:	83 ec 08             	sub    $0x8,%esp
80105ace:	68 61 8a 10 80       	push   $0x80108a61
80105ad3:	8d 45 ca             	lea    -0x36(%ebp),%eax
80105ad6:	50                   	push   %eax
80105ad7:	e8 d5 bf ff ff       	call   80101ab1 <namecmp>
80105adc:	83 c4 10             	add    $0x10,%esp
80105adf:	85 c0                	test   %eax,%eax
80105ae1:	0f 84 e0 00 00 00    	je     80105bc7 <sys_unlink+0x165>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105ae7:	83 ec 04             	sub    $0x4,%esp
80105aea:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105aed:	50                   	push   %eax
80105aee:	8d 45 ca             	lea    -0x36(%ebp),%eax
80105af1:	50                   	push   %eax
80105af2:	56                   	push   %esi
80105af3:	e8 d2 bf ff ff       	call   80101aca <dirlookup>
80105af8:	89 c3                	mov    %eax,%ebx
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	85 c0                	test   %eax,%eax
80105aff:	0f 84 c2 00 00 00    	je     80105bc7 <sys_unlink+0x165>
  ilock(ip);
80105b05:	83 ec 0c             	sub    $0xc,%esp
80105b08:	50                   	push   %eax
80105b09:	e8 6d bb ff ff       	call   8010167b <ilock>
  if(ip->nlink < 1)
80105b0e:	83 c4 10             	add    $0x10,%esp
80105b11:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105b16:	0f 8e 83 00 00 00    	jle    80105b9f <sys_unlink+0x13d>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b21:	0f 84 85 00 00 00    	je     80105bac <sys_unlink+0x14a>
  memset(&de, 0, sizeof(de));
80105b27:	83 ec 04             	sub    $0x4,%esp
80105b2a:	6a 10                	push   $0x10
80105b2c:	6a 00                	push   $0x0
80105b2e:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105b31:	57                   	push   %edi
80105b32:	e8 18 f6 ff ff       	call   8010514f <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b37:	6a 10                	push   $0x10
80105b39:	ff 75 c0             	pushl  -0x40(%ebp)
80105b3c:	57                   	push   %edi
80105b3d:	56                   	push   %esi
80105b3e:	e8 3f be ff ff       	call   80101982 <writei>
80105b43:	83 c4 20             	add    $0x20,%esp
80105b46:	83 f8 10             	cmp    $0x10,%eax
80105b49:	0f 85 90 00 00 00    	jne    80105bdf <sys_unlink+0x17d>
  if(ip->type == T_DIR){
80105b4f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b54:	0f 84 92 00 00 00    	je     80105bec <sys_unlink+0x18a>
  iunlockput(dp);
80105b5a:	83 ec 0c             	sub    $0xc,%esp
80105b5d:	56                   	push   %esi
80105b5e:	e8 cb bc ff ff       	call   8010182e <iunlockput>
  ip->nlink--;
80105b63:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80105b67:	83 e8 01             	sub    $0x1,%eax
80105b6a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80105b6e:	89 1c 24             	mov    %ebx,(%esp)
80105b71:	e8 9c b9 ff ff       	call   80101512 <iupdate>
  iunlockput(ip);
80105b76:	89 1c 24             	mov    %ebx,(%esp)
80105b79:	e8 b0 bc ff ff       	call   8010182e <iunlockput>
  end_op();
80105b7e:	e8 fb cd ff ff       	call   8010297e <end_op>
  return 0;
80105b83:	83 c4 10             	add    $0x10,%esp
80105b86:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b8e:	5b                   	pop    %ebx
80105b8f:	5e                   	pop    %esi
80105b90:	5f                   	pop    %edi
80105b91:	5d                   	pop    %ebp
80105b92:	c3                   	ret    
    end_op();
80105b93:	e8 e6 cd ff ff       	call   8010297e <end_op>
    return -1;
80105b98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9d:	eb ec                	jmp    80105b8b <sys_unlink+0x129>
    panic("unlink: nlink < 1");
80105b9f:	83 ec 0c             	sub    $0xc,%esp
80105ba2:	68 80 8a 10 80       	push   $0x80108a80
80105ba7:	e8 b0 a7 ff ff       	call   8010035c <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105bac:	89 d8                	mov    %ebx,%eax
80105bae:	e8 d3 f9 ff ff       	call   80105586 <isdirempty>
80105bb3:	85 c0                	test   %eax,%eax
80105bb5:	0f 85 6c ff ff ff    	jne    80105b27 <sys_unlink+0xc5>
    iunlockput(ip);
80105bbb:	83 ec 0c             	sub    $0xc,%esp
80105bbe:	53                   	push   %ebx
80105bbf:	e8 6a bc ff ff       	call   8010182e <iunlockput>
    goto bad;
80105bc4:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105bc7:	83 ec 0c             	sub    $0xc,%esp
80105bca:	56                   	push   %esi
80105bcb:	e8 5e bc ff ff       	call   8010182e <iunlockput>
  end_op();
80105bd0:	e8 a9 cd ff ff       	call   8010297e <end_op>
  return -1;
80105bd5:	83 c4 10             	add    $0x10,%esp
80105bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bdd:	eb ac                	jmp    80105b8b <sys_unlink+0x129>
    panic("unlink: writei");
80105bdf:	83 ec 0c             	sub    $0xc,%esp
80105be2:	68 92 8a 10 80       	push   $0x80108a92
80105be7:	e8 70 a7 ff ff       	call   8010035c <panic>
    dp->nlink--;
80105bec:	0f b7 46 56          	movzwl 0x56(%esi),%eax
80105bf0:	83 e8 01             	sub    $0x1,%eax
80105bf3:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80105bf7:	83 ec 0c             	sub    $0xc,%esp
80105bfa:	56                   	push   %esi
80105bfb:	e8 12 b9 ff ff       	call   80101512 <iupdate>
80105c00:	83 c4 10             	add    $0x10,%esp
80105c03:	e9 52 ff ff ff       	jmp    80105b5a <sys_unlink+0xf8>
    return -1;
80105c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c0d:	e9 79 ff ff ff       	jmp    80105b8b <sys_unlink+0x129>

80105c12 <sys_open>:

int
sys_open(void)
{
80105c12:	f3 0f 1e fb          	endbr32 
80105c16:	55                   	push   %ebp
80105c17:	89 e5                	mov    %esp,%ebp
80105c19:	57                   	push   %edi
80105c1a:	56                   	push   %esi
80105c1b:	53                   	push   %ebx
80105c1c:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c22:	50                   	push   %eax
80105c23:	6a 00                	push   $0x0
80105c25:	e8 33 f8 ff ff       	call   8010545d <argstr>
80105c2a:	83 c4 10             	add    $0x10,%esp
80105c2d:	85 c0                	test   %eax,%eax
80105c2f:	0f 88 a0 00 00 00    	js     80105cd5 <sys_open+0xc3>
80105c35:	83 ec 08             	sub    $0x8,%esp
80105c38:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c3b:	50                   	push   %eax
80105c3c:	6a 01                	push   $0x1
80105c3e:	e8 82 f7 ff ff       	call   801053c5 <argint>
80105c43:	83 c4 10             	add    $0x10,%esp
80105c46:	85 c0                	test   %eax,%eax
80105c48:	0f 88 87 00 00 00    	js     80105cd5 <sys_open+0xc3>
    return -1;

  begin_op();
80105c4e:	e8 ad cc ff ff       	call   80102900 <begin_op>

  if(omode & O_CREATE){
80105c53:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80105c57:	0f 84 8b 00 00 00    	je     80105ce8 <sys_open+0xd6>
    ip = create(path, T_FILE, 0, 0);
80105c5d:	83 ec 0c             	sub    $0xc,%esp
80105c60:	6a 00                	push   $0x0
80105c62:	b9 00 00 00 00       	mov    $0x0,%ecx
80105c67:	ba 02 00 00 00       	mov    $0x2,%edx
80105c6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c6f:	e8 69 f9 ff ff       	call   801055dd <create>
80105c74:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105c76:	83 c4 10             	add    $0x10,%esp
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	74 5f                	je     80105cdc <sys_open+0xca>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c7d:	e8 78 b0 ff ff       	call   80100cfa <filealloc>
80105c82:	89 c3                	mov    %eax,%ebx
80105c84:	85 c0                	test   %eax,%eax
80105c86:	0f 84 b5 00 00 00    	je     80105d41 <sys_open+0x12f>
80105c8c:	e8 be f8 ff ff       	call   8010554f <fdalloc>
80105c91:	89 c7                	mov    %eax,%edi
80105c93:	85 c0                	test   %eax,%eax
80105c95:	0f 88 a6 00 00 00    	js     80105d41 <sys_open+0x12f>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c9b:	83 ec 0c             	sub    $0xc,%esp
80105c9e:	56                   	push   %esi
80105c9f:	e8 9d ba ff ff       	call   80101741 <iunlock>
  end_op();
80105ca4:	e8 d5 cc ff ff       	call   8010297e <end_op>

  f->type = FD_INODE;
80105ca9:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80105caf:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80105cb2:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80105cb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105cbc:	83 c4 10             	add    $0x10,%esp
80105cbf:	a8 01                	test   $0x1,%al
80105cc1:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105cc5:	a8 03                	test   $0x3,%al
80105cc7:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80105ccb:	89 f8                	mov    %edi,%eax
80105ccd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cd0:	5b                   	pop    %ebx
80105cd1:	5e                   	pop    %esi
80105cd2:	5f                   	pop    %edi
80105cd3:	5d                   	pop    %ebp
80105cd4:	c3                   	ret    
    return -1;
80105cd5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80105cda:	eb ef                	jmp    80105ccb <sys_open+0xb9>
      end_op();
80105cdc:	e8 9d cc ff ff       	call   8010297e <end_op>
      return -1;
80105ce1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80105ce6:	eb e3                	jmp    80105ccb <sys_open+0xb9>
    if((ip = namei(path)) == 0){
80105ce8:	83 ec 0c             	sub    $0xc,%esp
80105ceb:	ff 75 e4             	pushl  -0x1c(%ebp)
80105cee:	e8 0d c0 ff ff       	call   80101d00 <namei>
80105cf3:	89 c6                	mov    %eax,%esi
80105cf5:	83 c4 10             	add    $0x10,%esp
80105cf8:	85 c0                	test   %eax,%eax
80105cfa:	74 39                	je     80105d35 <sys_open+0x123>
    ilock(ip);
80105cfc:	83 ec 0c             	sub    $0xc,%esp
80105cff:	50                   	push   %eax
80105d00:	e8 76 b9 ff ff       	call   8010167b <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d05:	83 c4 10             	add    $0x10,%esp
80105d08:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105d0d:	0f 85 6a ff ff ff    	jne    80105c7d <sys_open+0x6b>
80105d13:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80105d17:	0f 84 60 ff ff ff    	je     80105c7d <sys_open+0x6b>
      iunlockput(ip);
80105d1d:	83 ec 0c             	sub    $0xc,%esp
80105d20:	56                   	push   %esi
80105d21:	e8 08 bb ff ff       	call   8010182e <iunlockput>
      end_op();
80105d26:	e8 53 cc ff ff       	call   8010297e <end_op>
      return -1;
80105d2b:	83 c4 10             	add    $0x10,%esp
80105d2e:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80105d33:	eb 96                	jmp    80105ccb <sys_open+0xb9>
      end_op();
80105d35:	e8 44 cc ff ff       	call   8010297e <end_op>
      return -1;
80105d3a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80105d3f:	eb 8a                	jmp    80105ccb <sys_open+0xb9>
    if(f)
80105d41:	85 db                	test   %ebx,%ebx
80105d43:	74 0c                	je     80105d51 <sys_open+0x13f>
      fileclose(f);
80105d45:	83 ec 0c             	sub    $0xc,%esp
80105d48:	53                   	push   %ebx
80105d49:	e8 5a b0 ff ff       	call   80100da8 <fileclose>
80105d4e:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105d51:	83 ec 0c             	sub    $0xc,%esp
80105d54:	56                   	push   %esi
80105d55:	e8 d4 ba ff ff       	call   8010182e <iunlockput>
    end_op();
80105d5a:	e8 1f cc ff ff       	call   8010297e <end_op>
    return -1;
80105d5f:	83 c4 10             	add    $0x10,%esp
80105d62:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80105d67:	e9 5f ff ff ff       	jmp    80105ccb <sys_open+0xb9>

80105d6c <sys_mkdir>:

int
sys_mkdir(void)
{
80105d6c:	f3 0f 1e fb          	endbr32 
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105d76:	e8 85 cb ff ff       	call   80102900 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105d7b:	83 ec 08             	sub    $0x8,%esp
80105d7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d81:	50                   	push   %eax
80105d82:	6a 00                	push   $0x0
80105d84:	e8 d4 f6 ff ff       	call   8010545d <argstr>
80105d89:	83 c4 10             	add    $0x10,%esp
80105d8c:	85 c0                	test   %eax,%eax
80105d8e:	78 36                	js     80105dc6 <sys_mkdir+0x5a>
80105d90:	83 ec 0c             	sub    $0xc,%esp
80105d93:	6a 00                	push   $0x0
80105d95:	b9 00 00 00 00       	mov    $0x0,%ecx
80105d9a:	ba 01 00 00 00       	mov    $0x1,%edx
80105d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da2:	e8 36 f8 ff ff       	call   801055dd <create>
80105da7:	83 c4 10             	add    $0x10,%esp
80105daa:	85 c0                	test   %eax,%eax
80105dac:	74 18                	je     80105dc6 <sys_mkdir+0x5a>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105dae:	83 ec 0c             	sub    $0xc,%esp
80105db1:	50                   	push   %eax
80105db2:	e8 77 ba ff ff       	call   8010182e <iunlockput>
  end_op();
80105db7:	e8 c2 cb ff ff       	call   8010297e <end_op>
  return 0;
80105dbc:	83 c4 10             	add    $0x10,%esp
80105dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dc4:	c9                   	leave  
80105dc5:	c3                   	ret    
    end_op();
80105dc6:	e8 b3 cb ff ff       	call   8010297e <end_op>
    return -1;
80105dcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd0:	eb f2                	jmp    80105dc4 <sys_mkdir+0x58>

80105dd2 <sys_mknod>:

int
sys_mknod(void)
{
80105dd2:	f3 0f 1e fb          	endbr32 
80105dd6:	55                   	push   %ebp
80105dd7:	89 e5                	mov    %esp,%ebp
80105dd9:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105ddc:	e8 1f cb ff ff       	call   80102900 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105de1:	83 ec 08             	sub    $0x8,%esp
80105de4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105de7:	50                   	push   %eax
80105de8:	6a 00                	push   $0x0
80105dea:	e8 6e f6 ff ff       	call   8010545d <argstr>
80105def:	83 c4 10             	add    $0x10,%esp
80105df2:	85 c0                	test   %eax,%eax
80105df4:	78 62                	js     80105e58 <sys_mknod+0x86>
     argint(1, &major) < 0 ||
80105df6:	83 ec 08             	sub    $0x8,%esp
80105df9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dfc:	50                   	push   %eax
80105dfd:	6a 01                	push   $0x1
80105dff:	e8 c1 f5 ff ff       	call   801053c5 <argint>
  if((argstr(0, &path)) < 0 ||
80105e04:	83 c4 10             	add    $0x10,%esp
80105e07:	85 c0                	test   %eax,%eax
80105e09:	78 4d                	js     80105e58 <sys_mknod+0x86>
     argint(2, &minor) < 0 ||
80105e0b:	83 ec 08             	sub    $0x8,%esp
80105e0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e11:	50                   	push   %eax
80105e12:	6a 02                	push   $0x2
80105e14:	e8 ac f5 ff ff       	call   801053c5 <argint>
     argint(1, &major) < 0 ||
80105e19:	83 c4 10             	add    $0x10,%esp
80105e1c:	85 c0                	test   %eax,%eax
80105e1e:	78 38                	js     80105e58 <sys_mknod+0x86>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e20:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105e24:	83 ec 0c             	sub    $0xc,%esp
80105e27:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80105e2b:	50                   	push   %eax
80105e2c:	ba 03 00 00 00       	mov    $0x3,%edx
80105e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e34:	e8 a4 f7 ff ff       	call   801055dd <create>
     argint(2, &minor) < 0 ||
80105e39:	83 c4 10             	add    $0x10,%esp
80105e3c:	85 c0                	test   %eax,%eax
80105e3e:	74 18                	je     80105e58 <sys_mknod+0x86>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e40:	83 ec 0c             	sub    $0xc,%esp
80105e43:	50                   	push   %eax
80105e44:	e8 e5 b9 ff ff       	call   8010182e <iunlockput>
  end_op();
80105e49:	e8 30 cb ff ff       	call   8010297e <end_op>
  return 0;
80105e4e:	83 c4 10             	add    $0x10,%esp
80105e51:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e56:	c9                   	leave  
80105e57:	c3                   	ret    
    end_op();
80105e58:	e8 21 cb ff ff       	call   8010297e <end_op>
    return -1;
80105e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e62:	eb f2                	jmp    80105e56 <sys_mknod+0x84>

80105e64 <sys_chdir>:

int
sys_chdir(void)
{
80105e64:	f3 0f 1e fb          	endbr32 
80105e68:	55                   	push   %ebp
80105e69:	89 e5                	mov    %esp,%ebp
80105e6b:	56                   	push   %esi
80105e6c:	53                   	push   %ebx
80105e6d:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105e70:	e8 13 da ff ff       	call   80103888 <myproc>
80105e75:	89 c6                	mov    %eax,%esi

  begin_op();
80105e77:	e8 84 ca ff ff       	call   80102900 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105e7c:	83 ec 08             	sub    $0x8,%esp
80105e7f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e82:	50                   	push   %eax
80105e83:	6a 00                	push   $0x0
80105e85:	e8 d3 f5 ff ff       	call   8010545d <argstr>
80105e8a:	83 c4 10             	add    $0x10,%esp
80105e8d:	85 c0                	test   %eax,%eax
80105e8f:	78 52                	js     80105ee3 <sys_chdir+0x7f>
80105e91:	83 ec 0c             	sub    $0xc,%esp
80105e94:	ff 75 f4             	pushl  -0xc(%ebp)
80105e97:	e8 64 be ff ff       	call   80101d00 <namei>
80105e9c:	89 c3                	mov    %eax,%ebx
80105e9e:	83 c4 10             	add    $0x10,%esp
80105ea1:	85 c0                	test   %eax,%eax
80105ea3:	74 3e                	je     80105ee3 <sys_chdir+0x7f>
    end_op();
    return -1;
  }
  ilock(ip);
80105ea5:	83 ec 0c             	sub    $0xc,%esp
80105ea8:	50                   	push   %eax
80105ea9:	e8 cd b7 ff ff       	call   8010167b <ilock>
  if(ip->type != T_DIR){
80105eae:	83 c4 10             	add    $0x10,%esp
80105eb1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105eb6:	75 37                	jne    80105eef <sys_chdir+0x8b>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105eb8:	83 ec 0c             	sub    $0xc,%esp
80105ebb:	53                   	push   %ebx
80105ebc:	e8 80 b8 ff ff       	call   80101741 <iunlock>
  iput(curproc->cwd);
80105ec1:	83 c4 04             	add    $0x4,%esp
80105ec4:	ff 76 68             	pushl  0x68(%esi)
80105ec7:	e8 be b8 ff ff       	call   8010178a <iput>
  end_op();
80105ecc:	e8 ad ca ff ff       	call   8010297e <end_op>
  curproc->cwd = ip;
80105ed1:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105ed4:	83 c4 10             	add    $0x10,%esp
80105ed7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105edc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105edf:	5b                   	pop    %ebx
80105ee0:	5e                   	pop    %esi
80105ee1:	5d                   	pop    %ebp
80105ee2:	c3                   	ret    
    end_op();
80105ee3:	e8 96 ca ff ff       	call   8010297e <end_op>
    return -1;
80105ee8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eed:	eb ed                	jmp    80105edc <sys_chdir+0x78>
    iunlockput(ip);
80105eef:	83 ec 0c             	sub    $0xc,%esp
80105ef2:	53                   	push   %ebx
80105ef3:	e8 36 b9 ff ff       	call   8010182e <iunlockput>
    end_op();
80105ef8:	e8 81 ca ff ff       	call   8010297e <end_op>
    return -1;
80105efd:	83 c4 10             	add    $0x10,%esp
80105f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f05:	eb d5                	jmp    80105edc <sys_chdir+0x78>

80105f07 <sys_exec>:

int
sys_exec(void)
{
80105f07:	f3 0f 1e fb          	endbr32 
80105f0b:	55                   	push   %ebp
80105f0c:	89 e5                	mov    %esp,%ebp
80105f0e:	53                   	push   %ebx
80105f0f:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f15:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f18:	50                   	push   %eax
80105f19:	6a 00                	push   $0x0
80105f1b:	e8 3d f5 ff ff       	call   8010545d <argstr>
80105f20:	83 c4 10             	add    $0x10,%esp
80105f23:	85 c0                	test   %eax,%eax
80105f25:	78 38                	js     80105f5f <sys_exec+0x58>
80105f27:	83 ec 08             	sub    $0x8,%esp
80105f2a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105f30:	50                   	push   %eax
80105f31:	6a 01                	push   $0x1
80105f33:	e8 8d f4 ff ff       	call   801053c5 <argint>
80105f38:	83 c4 10             	add    $0x10,%esp
80105f3b:	85 c0                	test   %eax,%eax
80105f3d:	78 20                	js     80105f5f <sys_exec+0x58>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105f3f:	83 ec 04             	sub    $0x4,%esp
80105f42:	68 80 00 00 00       	push   $0x80
80105f47:	6a 00                	push   $0x0
80105f49:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80105f4f:	50                   	push   %eax
80105f50:	e8 fa f1 ff ff       	call   8010514f <memset>
80105f55:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80105f58:	bb 00 00 00 00       	mov    $0x0,%ebx
80105f5d:	eb 2c                	jmp    80105f8b <sys_exec+0x84>
    return -1;
80105f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f64:	eb 78                	jmp    80105fde <sys_exec+0xd7>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105f66:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80105f6d:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105f71:	83 ec 08             	sub    $0x8,%esp
80105f74:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80105f7a:	50                   	push   %eax
80105f7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f7e:	e8 2c aa ff ff       	call   801009af <exec>
80105f83:	83 c4 10             	add    $0x10,%esp
80105f86:	eb 56                	jmp    80105fde <sys_exec+0xd7>
  for(i=0;; i++){
80105f88:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105f8b:	83 fb 1f             	cmp    $0x1f,%ebx
80105f8e:	77 49                	ja     80105fd9 <sys_exec+0xd2>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105f90:	83 ec 08             	sub    $0x8,%esp
80105f93:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105f99:	50                   	push   %eax
80105f9a:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80105fa0:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105fa3:	50                   	push   %eax
80105fa4:	e8 98 f3 ff ff       	call   80105341 <fetchint>
80105fa9:	83 c4 10             	add    $0x10,%esp
80105fac:	85 c0                	test   %eax,%eax
80105fae:	78 33                	js     80105fe3 <sys_exec+0xdc>
    if(uarg == 0){
80105fb0:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105fb6:	85 c0                	test   %eax,%eax
80105fb8:	74 ac                	je     80105f66 <sys_exec+0x5f>
    if(fetchstr(uarg, &argv[i]) < 0)
80105fba:	83 ec 08             	sub    $0x8,%esp
80105fbd:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80105fc4:	52                   	push   %edx
80105fc5:	50                   	push   %eax
80105fc6:	e8 b6 f3 ff ff       	call   80105381 <fetchstr>
80105fcb:	83 c4 10             	add    $0x10,%esp
80105fce:	85 c0                	test   %eax,%eax
80105fd0:	79 b6                	jns    80105f88 <sys_exec+0x81>
      return -1;
80105fd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fd7:	eb 05                	jmp    80105fde <sys_exec+0xd7>
      return -1;
80105fd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fe1:	c9                   	leave  
80105fe2:	c3                   	ret    
      return -1;
80105fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe8:	eb f4                	jmp    80105fde <sys_exec+0xd7>

80105fea <sys_pipe>:

int
sys_pipe(void)
{
80105fea:	f3 0f 1e fb          	endbr32 
80105fee:	55                   	push   %ebp
80105fef:	89 e5                	mov    %esp,%ebp
80105ff1:	53                   	push   %ebx
80105ff2:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ff5:	6a 08                	push   $0x8
80105ff7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ffa:	50                   	push   %eax
80105ffb:	6a 00                	push   $0x0
80105ffd:	e8 ef f3 ff ff       	call   801053f1 <argptr>
80106002:	83 c4 10             	add    $0x10,%esp
80106005:	85 c0                	test   %eax,%eax
80106007:	78 79                	js     80106082 <sys_pipe+0x98>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106009:	83 ec 08             	sub    $0x8,%esp
8010600c:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010600f:	50                   	push   %eax
80106010:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106013:	50                   	push   %eax
80106014:	e8 8c ce ff ff       	call   80102ea5 <pipealloc>
80106019:	83 c4 10             	add    $0x10,%esp
8010601c:	85 c0                	test   %eax,%eax
8010601e:	78 69                	js     80106089 <sys_pipe+0x9f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106020:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106023:	e8 27 f5 ff ff       	call   8010554f <fdalloc>
80106028:	89 c3                	mov    %eax,%ebx
8010602a:	85 c0                	test   %eax,%eax
8010602c:	78 21                	js     8010604f <sys_pipe+0x65>
8010602e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106031:	e8 19 f5 ff ff       	call   8010554f <fdalloc>
80106036:	85 c0                	test   %eax,%eax
80106038:	78 15                	js     8010604f <sys_pipe+0x65>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010603a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010603d:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010603f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106042:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80106045:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010604a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010604d:	c9                   	leave  
8010604e:	c3                   	ret    
    if(fd0 >= 0)
8010604f:	85 db                	test   %ebx,%ebx
80106051:	79 20                	jns    80106073 <sys_pipe+0x89>
    fileclose(rf);
80106053:	83 ec 0c             	sub    $0xc,%esp
80106056:	ff 75 f0             	pushl  -0x10(%ebp)
80106059:	e8 4a ad ff ff       	call   80100da8 <fileclose>
    fileclose(wf);
8010605e:	83 c4 04             	add    $0x4,%esp
80106061:	ff 75 ec             	pushl  -0x14(%ebp)
80106064:	e8 3f ad ff ff       	call   80100da8 <fileclose>
    return -1;
80106069:	83 c4 10             	add    $0x10,%esp
8010606c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106071:	eb d7                	jmp    8010604a <sys_pipe+0x60>
      myproc()->ofile[fd0] = 0;
80106073:	e8 10 d8 ff ff       	call   80103888 <myproc>
80106078:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010607f:	00 
80106080:	eb d1                	jmp    80106053 <sys_pipe+0x69>
    return -1;
80106082:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106087:	eb c1                	jmp    8010604a <sys_pipe+0x60>
    return -1;
80106089:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010608e:	eb ba                	jmp    8010604a <sys_pipe+0x60>

80106090 <sys_fork>:
#endif // PDX_XV6
#include "uproc.h"

int
sys_fork(void)
{
80106090:	f3 0f 1e fb          	endbr32 
80106094:	55                   	push   %ebp
80106095:	89 e5                	mov    %esp,%ebp
80106097:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010609a:	e8 fc d9 ff ff       	call   80103a9b <fork>
}
8010609f:	c9                   	leave  
801060a0:	c3                   	ret    

801060a1 <sys_exit>:

int
sys_exit(void)
{
801060a1:	f3 0f 1e fb          	endbr32 
801060a5:	55                   	push   %ebp
801060a6:	89 e5                	mov    %esp,%ebp
801060a8:	83 ec 08             	sub    $0x8,%esp
  exit();
801060ab:	e8 aa dd ff ff       	call   80103e5a <exit>
  return 0;  // not reached
}
801060b0:	b8 00 00 00 00       	mov    $0x0,%eax
801060b5:	c9                   	leave  
801060b6:	c3                   	ret    

801060b7 <sys_wait>:

int
sys_wait(void)
{
801060b7:	f3 0f 1e fb          	endbr32 
801060bb:	55                   	push   %ebp
801060bc:	89 e5                	mov    %esp,%ebp
801060be:	83 ec 08             	sub    $0x8,%esp
  return wait();
801060c1:	e8 3f e1 ff ff       	call   80104205 <wait>
}
801060c6:	c9                   	leave  
801060c7:	c3                   	ret    

801060c8 <sys_kill>:

int
sys_kill(void)
{
801060c8:	f3 0f 1e fb          	endbr32 
801060cc:	55                   	push   %ebp
801060cd:	89 e5                	mov    %esp,%ebp
801060cf:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801060d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060d5:	50                   	push   %eax
801060d6:	6a 00                	push   $0x0
801060d8:	e8 e8 f2 ff ff       	call   801053c5 <argint>
801060dd:	83 c4 10             	add    $0x10,%esp
801060e0:	85 c0                	test   %eax,%eax
801060e2:	78 10                	js     801060f4 <sys_kill+0x2c>
    return -1;
  return kill(pid);
801060e4:	83 ec 0c             	sub    $0xc,%esp
801060e7:	ff 75 f4             	pushl  -0xc(%ebp)
801060ea:	e8 1e e3 ff ff       	call   8010440d <kill>
801060ef:	83 c4 10             	add    $0x10,%esp
}
801060f2:	c9                   	leave  
801060f3:	c3                   	ret    
    return -1;
801060f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060f9:	eb f7                	jmp    801060f2 <sys_kill+0x2a>

801060fb <sys_getpid>:

int
sys_getpid(void)
{
801060fb:	f3 0f 1e fb          	endbr32 
801060ff:	55                   	push   %ebp
80106100:	89 e5                	mov    %esp,%ebp
80106102:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106105:	e8 7e d7 ff ff       	call   80103888 <myproc>
8010610a:	8b 40 10             	mov    0x10(%eax),%eax
}
8010610d:	c9                   	leave  
8010610e:	c3                   	ret    

8010610f <sys_sbrk>:

int
sys_sbrk(void)
{
8010610f:	f3 0f 1e fb          	endbr32 
80106113:	55                   	push   %ebp
80106114:	89 e5                	mov    %esp,%ebp
80106116:	53                   	push   %ebx
80106117:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010611a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010611d:	50                   	push   %eax
8010611e:	6a 00                	push   $0x0
80106120:	e8 a0 f2 ff ff       	call   801053c5 <argint>
80106125:	83 c4 10             	add    $0x10,%esp
80106128:	85 c0                	test   %eax,%eax
8010612a:	78 20                	js     8010614c <sys_sbrk+0x3d>
    return -1;
  addr = myproc()->sz;
8010612c:	e8 57 d7 ff ff       	call   80103888 <myproc>
80106131:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106133:	83 ec 0c             	sub    $0xc,%esp
80106136:	ff 75 f4             	pushl  -0xc(%ebp)
80106139:	e8 ee d8 ff ff       	call   80103a2c <growproc>
8010613e:	83 c4 10             	add    $0x10,%esp
80106141:	85 c0                	test   %eax,%eax
80106143:	78 0e                	js     80106153 <sys_sbrk+0x44>
    return -1;
  return addr;
}
80106145:	89 d8                	mov    %ebx,%eax
80106147:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010614a:	c9                   	leave  
8010614b:	c3                   	ret    
    return -1;
8010614c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106151:	eb f2                	jmp    80106145 <sys_sbrk+0x36>
    return -1;
80106153:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106158:	eb eb                	jmp    80106145 <sys_sbrk+0x36>

8010615a <sys_sleep>:

int
sys_sleep(void)
{
8010615a:	f3 0f 1e fb          	endbr32 
8010615e:	55                   	push   %ebp
8010615f:	89 e5                	mov    %esp,%ebp
80106161:	53                   	push   %ebx
80106162:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106165:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106168:	50                   	push   %eax
80106169:	6a 00                	push   $0x0
8010616b:	e8 55 f2 ff ff       	call   801053c5 <argint>
80106170:	83 c4 10             	add    $0x10,%esp
80106173:	85 c0                	test   %eax,%eax
80106175:	78 3b                	js     801061b2 <sys_sleep+0x58>
    return -1;
  ticks0 = ticks;
80106177:	8b 1d 00 6d 11 80    	mov    0x80116d00,%ebx
  while(ticks - ticks0 < n){
8010617d:	a1 00 6d 11 80       	mov    0x80116d00,%eax
80106182:	29 d8                	sub    %ebx,%eax
80106184:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106187:	73 1f                	jae    801061a8 <sys_sleep+0x4e>
    if(myproc()->killed){
80106189:	e8 fa d6 ff ff       	call   80103888 <myproc>
8010618e:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80106192:	75 25                	jne    801061b9 <sys_sleep+0x5f>
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
80106194:	83 ec 08             	sub    $0x8,%esp
80106197:	6a 00                	push   $0x0
80106199:	68 00 6d 11 80       	push   $0x80116d00
8010619e:	e8 3e df ff ff       	call   801040e1 <sleep>
801061a3:	83 c4 10             	add    $0x10,%esp
801061a6:	eb d5                	jmp    8010617d <sys_sleep+0x23>
  }
  return 0;
801061a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801061b0:	c9                   	leave  
801061b1:	c3                   	ret    
    return -1;
801061b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b7:	eb f4                	jmp    801061ad <sys_sleep+0x53>
      return -1;
801061b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061be:	eb ed                	jmp    801061ad <sys_sleep+0x53>

801061c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801061c0:	f3 0f 1e fb          	endbr32 
  uint xticks;

  xticks = ticks;
  return xticks;
}
801061c4:	a1 00 6d 11 80       	mov    0x80116d00,%eax
801061c9:	c3                   	ret    

801061ca <sys_halt>:

#ifdef PDX_XV6
// shutdown QEMU
int
sys_halt(void)
{
801061ca:	f3 0f 1e fb          	endbr32 
801061ce:	55                   	push   %ebp
801061cf:	89 e5                	mov    %esp,%ebp
801061d1:	83 ec 08             	sub    $0x8,%esp
  do_shutdown();  // never returns
801061d4:	e8 80 a5 ff ff       	call   80100759 <do_shutdown>
  return 0;
}
801061d9:	b8 00 00 00 00       	mov    $0x0,%eax
801061de:	c9                   	leave  
801061df:	c3                   	ret    

801061e0 <sys_date>:
#endif // PDX_XV6

//new system calls and implementations here
int
sys_date(void)
{ 
801061e0:	f3 0f 1e fb          	endbr32 
801061e4:	55                   	push   %ebp
801061e5:	89 e5                	mov    %esp,%ebp
801061e7:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *d;

  if(argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0)
801061ea:	6a 18                	push   $0x18
801061ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061ef:	50                   	push   %eax
801061f0:	6a 00                	push   $0x0
801061f2:	e8 fa f1 ff ff       	call   801053f1 <argptr>
801061f7:	83 c4 10             	add    $0x10,%esp
801061fa:	85 c0                	test   %eax,%eax
801061fc:	78 15                	js     80106213 <sys_date+0x33>
    return -1; //failure
  //the rest of the implementation is left as an exercise to the student
  cmostime(d);
801061fe:	83 ec 0c             	sub    $0xc,%esp
80106201:	ff 75 f4             	pushl  -0xc(%ebp)
80106204:	e8 a4 c3 ff ff       	call   801025ad <cmostime>
  return 0;    //success
80106209:	83 c4 10             	add    $0x10,%esp
8010620c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106211:	c9                   	leave  
80106212:	c3                   	ret    
    return -1; //failure
80106213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106218:	eb f7                	jmp    80106211 <sys_date+0x31>

8010621a <sys_getuid>:

#ifdef CS333_P2
int
sys_getuid(void)
{
8010621a:	f3 0f 1e fb          	endbr32 
8010621e:	55                   	push   %ebp
8010621f:	89 e5                	mov    %esp,%ebp
80106221:	83 ec 08             	sub    $0x8,%esp
  return myproc()->uid;
80106224:	e8 5f d6 ff ff       	call   80103888 <myproc>
80106229:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
8010622f:	c9                   	leave  
80106230:	c3                   	ret    

80106231 <sys_getgid>:

int
sys_getgid(void)
{
80106231:	f3 0f 1e fb          	endbr32 
80106235:	55                   	push   %ebp
80106236:	89 e5                	mov    %esp,%ebp
80106238:	83 ec 08             	sub    $0x8,%esp
  return myproc()->gid;
8010623b:	e8 48 d6 ff ff       	call   80103888 <myproc>
80106240:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80106246:	c9                   	leave  
80106247:	c3                   	ret    

80106248 <sys_getppid>:

int
sys_getppid(void)
{
80106248:	f3 0f 1e fb          	endbr32 
8010624c:	55                   	push   %ebp
8010624d:	89 e5                	mov    %esp,%ebp
8010624f:	83 ec 08             	sub    $0x8,%esp
  if(myproc()->parent == NULL)
80106252:	e8 31 d6 ff ff       	call   80103888 <myproc>
80106257:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
8010625b:	74 0d                	je     8010626a <sys_getppid+0x22>
    return myproc()->pid;
  return myproc()->parent->pid;
8010625d:	e8 26 d6 ff ff       	call   80103888 <myproc>
80106262:	8b 40 14             	mov    0x14(%eax),%eax
80106265:	8b 40 10             	mov    0x10(%eax),%eax
}
80106268:	c9                   	leave  
80106269:	c3                   	ret    
    return myproc()->pid;
8010626a:	e8 19 d6 ff ff       	call   80103888 <myproc>
8010626f:	8b 40 10             	mov    0x10(%eax),%eax
80106272:	eb f4                	jmp    80106268 <sys_getppid+0x20>

80106274 <sys_setuid>:

int
sys_setuid(void)
{
80106274:	f3 0f 1e fb          	endbr32 
80106278:	55                   	push   %ebp
80106279:	89 e5                	mov    %esp,%ebp
8010627b:	53                   	push   %ebx
8010627c:	83 ec 1c             	sub    $0x1c,%esp
  int uid;
  if(argint(0, &uid) < 0)
8010627f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106282:	50                   	push   %eax
80106283:	6a 00                	push   $0x0
80106285:	e8 3b f1 ff ff       	call   801053c5 <argint>
8010628a:	83 c4 10             	add    $0x10,%esp
8010628d:	85 c0                	test   %eax,%eax
8010628f:	78 20                	js     801062b1 <sys_setuid+0x3d>
    return -1;

  if(uid < 0  || uid > 32767)
80106291:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80106294:	81 fb ff 7f 00 00    	cmp    $0x7fff,%ebx
8010629a:	77 1c                	ja     801062b8 <sys_setuid+0x44>
    return -1;

  myproc()->uid = uid;
8010629c:	e8 e7 d5 ff ff       	call   80103888 <myproc>
801062a1:	89 98 80 00 00 00    	mov    %ebx,0x80(%eax)
  return 0;
801062a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062af:	c9                   	leave  
801062b0:	c3                   	ret    
    return -1;
801062b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b6:	eb f4                	jmp    801062ac <sys_setuid+0x38>
    return -1;
801062b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062bd:	eb ed                	jmp    801062ac <sys_setuid+0x38>

801062bf <sys_setgid>:

int 
sys_setgid(void)
{
801062bf:	f3 0f 1e fb          	endbr32 
801062c3:	55                   	push   %ebp
801062c4:	89 e5                	mov    %esp,%ebp
801062c6:	53                   	push   %ebx
801062c7:	83 ec 1c             	sub    $0x1c,%esp
  int gid;
  if(argint(0, &gid) < 0)
801062ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062cd:	50                   	push   %eax
801062ce:	6a 00                	push   $0x0
801062d0:	e8 f0 f0 ff ff       	call   801053c5 <argint>
801062d5:	83 c4 10             	add    $0x10,%esp
801062d8:	85 c0                	test   %eax,%eax
801062da:	78 20                	js     801062fc <sys_setgid+0x3d>
    return -1;
  if(gid < 0 || gid > 32767)
801062dc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801062df:	81 fb ff 7f 00 00    	cmp    $0x7fff,%ebx
801062e5:	77 1c                	ja     80106303 <sys_setgid+0x44>
    return -1;
  
  myproc()->gid = gid;
801062e7:	e8 9c d5 ff ff       	call   80103888 <myproc>
801062ec:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
  return 0;
801062f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062fa:	c9                   	leave  
801062fb:	c3                   	ret    
    return -1;
801062fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106301:	eb f4                	jmp    801062f7 <sys_setgid+0x38>
    return -1;
80106303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106308:	eb ed                	jmp    801062f7 <sys_setgid+0x38>

8010630a <sys_getprocs>:

int
sys_getprocs(void)
{
8010630a:	f3 0f 1e fb          	endbr32 
8010630e:	55                   	push   %ebp
8010630f:	89 e5                	mov    %esp,%ebp
80106311:	83 ec 20             	sub    $0x20,%esp
  struct uproc * table;
  int max;
  if(argint(0, &max) < 0)
80106314:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106317:	50                   	push   %eax
80106318:	6a 00                	push   $0x0
8010631a:	e8 a6 f0 ff ff       	call   801053c5 <argint>
8010631f:	83 c4 10             	add    $0x10,%esp
80106322:	85 c0                	test   %eax,%eax
80106324:	78 32                	js     80106358 <sys_getprocs+0x4e>
    return -1;
 
  if(argptr(1, (void*)&table, max * sizeof(struct uproc)) < 0)
80106326:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106329:	8d 04 40             	lea    (%eax,%eax,2),%eax
8010632c:	c1 e0 05             	shl    $0x5,%eax
8010632f:	83 ec 04             	sub    $0x4,%esp
80106332:	50                   	push   %eax
80106333:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106336:	50                   	push   %eax
80106337:	6a 01                	push   $0x1
80106339:	e8 b3 f0 ff ff       	call   801053f1 <argptr>
8010633e:	83 c4 10             	add    $0x10,%esp
80106341:	85 c0                	test   %eax,%eax
80106343:	78 1a                	js     8010635f <sys_getprocs+0x55>
    return -1;
  int catch = getprocs(max, table);
80106345:	83 ec 08             	sub    $0x8,%esp
80106348:	ff 75 f4             	pushl  -0xc(%ebp)
8010634b:	ff 75 f0             	pushl  -0x10(%ebp)
8010634e:	e8 b5 e9 ff ff       	call   80104d08 <getprocs>
  
  return catch;
80106353:	83 c4 10             	add    $0x10,%esp
}
80106356:	c9                   	leave  
80106357:	c3                   	ret    
    return -1;
80106358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010635d:	eb f7                	jmp    80106356 <sys_getprocs+0x4c>
    return -1;
8010635f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106364:	eb f0                	jmp    80106356 <sys_getprocs+0x4c>

80106366 <sys_setpriority>:
#endif //CS333_P2
#ifdef CS333_P4
int
sys_setpriority(void)
{
80106366:	f3 0f 1e fb          	endbr32 
8010636a:	55                   	push   %ebp
8010636b:	89 e5                	mov    %esp,%ebp
8010636d:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int priority;
  if(argint(0, &pid) < 0)
80106370:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106373:	50                   	push   %eax
80106374:	6a 00                	push   $0x0
80106376:	e8 4a f0 ff ff       	call   801053c5 <argint>
8010637b:	83 c4 10             	add    $0x10,%esp
8010637e:	85 c0                	test   %eax,%eax
80106380:	78 37                	js     801063b9 <sys_setpriority+0x53>
    return -1;
  if(argint(1, &priority) < 0)
80106382:	83 ec 08             	sub    $0x8,%esp
80106385:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106388:	50                   	push   %eax
80106389:	6a 01                	push   $0x1
8010638b:	e8 35 f0 ff ff       	call   801053c5 <argint>
80106390:	83 c4 10             	add    $0x10,%esp
80106393:	85 c0                	test   %eax,%eax
80106395:	78 29                	js     801063c0 <sys_setpriority+0x5a>
    return -1;
  if(pid < 0 || priority < 0 || priority > MAXPRIO)
80106397:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010639a:	85 d2                	test   %edx,%edx
8010639c:	78 29                	js     801063c7 <sys_setpriority+0x61>
8010639e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a1:	85 c0                	test   %eax,%eax
801063a3:	78 29                	js     801063ce <sys_setpriority+0x68>
801063a5:	83 f8 06             	cmp    $0x6,%eax
801063a8:	7f 2b                	jg     801063d5 <sys_setpriority+0x6f>
    return -1;
  return setpriority(pid, priority);
801063aa:	83 ec 08             	sub    $0x8,%esp
801063ad:	50                   	push   %eax
801063ae:	52                   	push   %edx
801063af:	e8 5f e6 ff ff       	call   80104a13 <setpriority>
801063b4:	83 c4 10             	add    $0x10,%esp
}
801063b7:	c9                   	leave  
801063b8:	c3                   	ret    
    return -1;
801063b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063be:	eb f7                	jmp    801063b7 <sys_setpriority+0x51>
    return -1;
801063c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063c5:	eb f0                	jmp    801063b7 <sys_setpriority+0x51>
    return -1;
801063c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063cc:	eb e9                	jmp    801063b7 <sys_setpriority+0x51>
801063ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063d3:	eb e2                	jmp    801063b7 <sys_setpriority+0x51>
801063d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063da:	eb db                	jmp    801063b7 <sys_setpriority+0x51>

801063dc <sys_getpriority>:

int
sys_getpriority(void)
{
801063dc:	f3 0f 1e fb          	endbr32 
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0)
801063e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063e9:	50                   	push   %eax
801063ea:	6a 00                	push   $0x0
801063ec:	e8 d4 ef ff ff       	call   801053c5 <argint>
801063f1:	83 c4 10             	add    $0x10,%esp
801063f4:	85 c0                	test   %eax,%eax
801063f6:	78 10                	js     80106408 <sys_getpriority+0x2c>
    return -1;
  return getpriority(pid);
801063f8:	83 ec 0c             	sub    $0xc,%esp
801063fb:	ff 75 f4             	pushl  -0xc(%ebp)
801063fe:	e8 23 e8 ff ff       	call   80104c26 <getpriority>
80106403:	83 c4 10             	add    $0x10,%esp
}
80106406:	c9                   	leave  
80106407:	c3                   	ret    
    return -1;
80106408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010640d:	eb f7                	jmp    80106406 <sys_getpriority+0x2a>

8010640f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010640f:	1e                   	push   %ds
  pushl %es
80106410:	06                   	push   %es
  pushl %fs
80106411:	0f a0                	push   %fs
  pushl %gs
80106413:	0f a8                	push   %gs
  pushal
80106415:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106416:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010641a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010641c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010641e:	54                   	push   %esp
  call trap
8010641f:	e8 cf 00 00 00       	call   801064f3 <trap>
  addl $4, %esp
80106424:	83 c4 04             	add    $0x4,%esp

80106427 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106427:	61                   	popa   
  popl %gs
80106428:	0f a9                	pop    %gs
  popl %fs
8010642a:	0f a1                	pop    %fs
  popl %es
8010642c:	07                   	pop    %es
  popl %ds
8010642d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010642e:	83 c4 08             	add    $0x8,%esp
  iret
80106431:	cf                   	iret   

80106432 <tvinit>:
uint ticks;
#endif // PDX_XV6

void
tvinit(void)
{
80106432:	f3 0f 1e fb          	endbr32 
  int i;

  for(i = 0; i < 256; i++)
80106436:	b8 00 00 00 00       	mov    $0x0,%eax
8010643b:	3d ff 00 00 00       	cmp    $0xff,%eax
80106440:	7f 4c                	jg     8010648e <tvinit+0x5c>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106442:	8b 0c 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%ecx
80106449:	66 89 0c c5 00 65 11 	mov    %cx,-0x7fee9b00(,%eax,8)
80106450:	80 
80106451:	66 c7 04 c5 02 65 11 	movw   $0x8,-0x7fee9afe(,%eax,8)
80106458:	80 08 00 
8010645b:	c6 04 c5 04 65 11 80 	movb   $0x0,-0x7fee9afc(,%eax,8)
80106462:	00 
80106463:	0f b6 14 c5 05 65 11 	movzbl -0x7fee9afb(,%eax,8),%edx
8010646a:	80 
8010646b:	83 e2 f0             	and    $0xfffffff0,%edx
8010646e:	83 ca 0e             	or     $0xe,%edx
80106471:	83 e2 8f             	and    $0xffffff8f,%edx
80106474:	83 ca 80             	or     $0xffffff80,%edx
80106477:	88 14 c5 05 65 11 80 	mov    %dl,-0x7fee9afb(,%eax,8)
8010647e:	c1 e9 10             	shr    $0x10,%ecx
80106481:	66 89 0c c5 06 65 11 	mov    %cx,-0x7fee9afa(,%eax,8)
80106488:	80 
  for(i = 0; i < 256; i++)
80106489:	83 c0 01             	add    $0x1,%eax
8010648c:	eb ad                	jmp    8010643b <tvinit+0x9>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010648e:	8b 15 08 b1 10 80    	mov    0x8010b108,%edx
80106494:	66 89 15 00 67 11 80 	mov    %dx,0x80116700
8010649b:	66 c7 05 02 67 11 80 	movw   $0x8,0x80116702
801064a2:	08 00 
801064a4:	c6 05 04 67 11 80 00 	movb   $0x0,0x80116704
801064ab:	0f b6 05 05 67 11 80 	movzbl 0x80116705,%eax
801064b2:	83 c8 0f             	or     $0xf,%eax
801064b5:	83 e0 ef             	and    $0xffffffef,%eax
801064b8:	83 c8 e0             	or     $0xffffffe0,%eax
801064bb:	a2 05 67 11 80       	mov    %al,0x80116705
801064c0:	c1 ea 10             	shr    $0x10,%edx
801064c3:	66 89 15 06 67 11 80 	mov    %dx,0x80116706

#ifndef PDX_XV6
  initlock(&tickslock, "time");
#endif // PDX_XV6
}
801064ca:	c3                   	ret    

801064cb <idtinit>:

void
idtinit(void)
{
801064cb:	f3 0f 1e fb          	endbr32 
801064cf:	55                   	push   %ebp
801064d0:	89 e5                	mov    %esp,%ebp
801064d2:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801064d5:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
801064db:	b8 00 65 11 80       	mov    $0x80116500,%eax
801064e0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801064e4:	c1 e8 10             	shr    $0x10,%eax
801064e7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801064eb:	8d 45 fa             	lea    -0x6(%ebp),%eax
801064ee:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801064f1:	c9                   	leave  
801064f2:	c3                   	ret    

801064f3 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801064f3:	f3 0f 1e fb          	endbr32 
801064f7:	55                   	push   %ebp
801064f8:	89 e5                	mov    %esp,%ebp
801064fa:	57                   	push   %edi
801064fb:	56                   	push   %esi
801064fc:	53                   	push   %ebx
801064fd:	83 ec 1c             	sub    $0x1c,%esp
80106500:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106503:	8b 43 30             	mov    0x30(%ebx),%eax
80106506:	83 f8 40             	cmp    $0x40,%eax
80106509:	74 14                	je     8010651f <trap+0x2c>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010650b:	83 e8 20             	sub    $0x20,%eax
8010650e:	83 f8 1f             	cmp    $0x1f,%eax
80106511:	0f 87 23 01 00 00    	ja     8010663a <trap+0x147>
80106517:	3e ff 24 85 44 8b 10 	notrack jmp *-0x7fef74bc(,%eax,4)
8010651e:	80 
    if(myproc()->killed)
8010651f:	e8 64 d3 ff ff       	call   80103888 <myproc>
80106524:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80106528:	75 1f                	jne    80106549 <trap+0x56>
    myproc()->tf = tf;
8010652a:	e8 59 d3 ff ff       	call   80103888 <myproc>
8010652f:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106532:	e8 5d ef ff ff       	call   80105494 <syscall>
    if(myproc()->killed)
80106537:	e8 4c d3 ff ff       	call   80103888 <myproc>
8010653c:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80106540:	74 7e                	je     801065c0 <trap+0xcd>
      exit();
80106542:	e8 13 d9 ff ff       	call   80103e5a <exit>
    return;
80106547:	eb 77                	jmp    801065c0 <trap+0xcd>
      exit();
80106549:	e8 0c d9 ff ff       	call   80103e5a <exit>
8010654e:	eb da                	jmp    8010652a <trap+0x37>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106550:	e8 14 d3 ff ff       	call   80103869 <cpuid>
80106555:	85 c0                	test   %eax,%eax
80106557:	74 6f                	je     801065c8 <trap+0xd5>
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
#endif // PDX_XV6
    }
    lapiceoi();
80106559:	e8 86 bf ff ff       	call   801024e4 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010655e:	e8 25 d3 ff ff       	call   80103888 <myproc>
80106563:	85 c0                	test   %eax,%eax
80106565:	74 1c                	je     80106583 <trap+0x90>
80106567:	e8 1c d3 ff ff       	call   80103888 <myproc>
8010656c:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80106570:	74 11                	je     80106583 <trap+0x90>
80106572:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106576:	83 e0 03             	and    $0x3,%eax
80106579:	66 83 f8 03          	cmp    $0x3,%ax
8010657d:	0f 84 4a 01 00 00    	je     801066cd <trap+0x1da>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106583:	e8 00 d3 ff ff       	call   80103888 <myproc>
80106588:	85 c0                	test   %eax,%eax
8010658a:	74 0f                	je     8010659b <trap+0xa8>
8010658c:	e8 f7 d2 ff ff       	call   80103888 <myproc>
80106591:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106595:	0f 84 3c 01 00 00    	je     801066d7 <trap+0x1e4>
    tf->trapno == T_IRQ0+IRQ_TIMER)
#endif // PDX_XV6
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010659b:	e8 e8 d2 ff ff       	call   80103888 <myproc>
801065a0:	85 c0                	test   %eax,%eax
801065a2:	74 1c                	je     801065c0 <trap+0xcd>
801065a4:	e8 df d2 ff ff       	call   80103888 <myproc>
801065a9:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801065ad:	74 11                	je     801065c0 <trap+0xcd>
801065af:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801065b3:	83 e0 03             	and    $0x3,%eax
801065b6:	66 83 f8 03          	cmp    $0x3,%ax
801065ba:	0f 84 4a 01 00 00    	je     8010670a <trap+0x217>
    exit();
}
801065c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065c3:	5b                   	pop    %ebx
801065c4:	5e                   	pop    %esi
801065c5:	5f                   	pop    %edi
801065c6:	5d                   	pop    %ebp
801065c7:	c3                   	ret    
// atom_inc() necessary for removal of tickslock
// other atomic ops added for completeness
static inline void
atom_inc(volatile int *num)
{
  asm volatile ( "lock incl %0" : "=m" (*num));
801065c8:	f0 ff 05 00 6d 11 80 	lock incl 0x80116d00
      wakeup(&ticks);
801065cf:	83 ec 0c             	sub    $0xc,%esp
801065d2:	68 00 6d 11 80       	push   $0x80116d00
801065d7:	e8 04 de ff ff       	call   801043e0 <wakeup>
801065dc:	83 c4 10             	add    $0x10,%esp
801065df:	e9 75 ff ff ff       	jmp    80106559 <trap+0x66>
    ideintr();
801065e4:	e8 b4 b8 ff ff       	call   80101e9d <ideintr>
    lapiceoi();
801065e9:	e8 f6 be ff ff       	call   801024e4 <lapiceoi>
    break;
801065ee:	e9 6b ff ff ff       	jmp    8010655e <trap+0x6b>
    kbdintr();
801065f3:	e8 29 bd ff ff       	call   80102321 <kbdintr>
    lapiceoi();
801065f8:	e8 e7 be ff ff       	call   801024e4 <lapiceoi>
    break;
801065fd:	e9 5c ff ff ff       	jmp    8010655e <trap+0x6b>
    uartintr();
80106602:	e8 29 02 00 00       	call   80106830 <uartintr>
    lapiceoi();
80106607:	e8 d8 be ff ff       	call   801024e4 <lapiceoi>
    break;
8010660c:	e9 4d ff ff ff       	jmp    8010655e <trap+0x6b>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106611:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80106614:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106618:	e8 4c d2 ff ff       	call   80103869 <cpuid>
8010661d:	57                   	push   %edi
8010661e:	0f b7 f6             	movzwl %si,%esi
80106621:	56                   	push   %esi
80106622:	50                   	push   %eax
80106623:	68 a4 8a 10 80       	push   $0x80108aa4
80106628:	e8 fc 9f ff ff       	call   80100629 <cprintf>
    lapiceoi();
8010662d:	e8 b2 be ff ff       	call   801024e4 <lapiceoi>
    break;
80106632:	83 c4 10             	add    $0x10,%esp
80106635:	e9 24 ff ff ff       	jmp    8010655e <trap+0x6b>
    if(myproc() == 0 || (tf->cs&3) == 0){
8010663a:	e8 49 d2 ff ff       	call   80103888 <myproc>
8010663f:	85 c0                	test   %eax,%eax
80106641:	74 5f                	je     801066a2 <trap+0x1af>
80106643:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106647:	74 59                	je     801066a2 <trap+0x1af>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106649:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010664c:	8b 43 38             	mov    0x38(%ebx),%eax
8010664f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106652:	e8 12 d2 ff ff       	call   80103869 <cpuid>
80106657:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010665a:	8b 4b 34             	mov    0x34(%ebx),%ecx
8010665d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80106660:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80106663:	e8 20 d2 ff ff       	call   80103888 <myproc>
80106668:	8d 50 6c             	lea    0x6c(%eax),%edx
8010666b:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010666e:	e8 15 d2 ff ff       	call   80103888 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106673:	57                   	push   %edi
80106674:	ff 75 e4             	pushl  -0x1c(%ebp)
80106677:	ff 75 e0             	pushl  -0x20(%ebp)
8010667a:	ff 75 dc             	pushl  -0x24(%ebp)
8010667d:	56                   	push   %esi
8010667e:	ff 75 d8             	pushl  -0x28(%ebp)
80106681:	ff 70 10             	pushl  0x10(%eax)
80106684:	68 fc 8a 10 80       	push   $0x80108afc
80106689:	e8 9b 9f ff ff       	call   80100629 <cprintf>
    myproc()->killed = 1;
8010668e:	83 c4 20             	add    $0x20,%esp
80106691:	e8 f2 d1 ff ff       	call   80103888 <myproc>
80106696:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010669d:	e9 bc fe ff ff       	jmp    8010655e <trap+0x6b>
801066a2:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801066a5:	8b 73 38             	mov    0x38(%ebx),%esi
801066a8:	e8 bc d1 ff ff       	call   80103869 <cpuid>
801066ad:	83 ec 0c             	sub    $0xc,%esp
801066b0:	57                   	push   %edi
801066b1:	56                   	push   %esi
801066b2:	50                   	push   %eax
801066b3:	ff 73 30             	pushl  0x30(%ebx)
801066b6:	68 c8 8a 10 80       	push   $0x80108ac8
801066bb:	e8 69 9f ff ff       	call   80100629 <cprintf>
      panic("trap");
801066c0:	83 c4 14             	add    $0x14,%esp
801066c3:	68 3f 8b 10 80       	push   $0x80108b3f
801066c8:	e8 8f 9c ff ff       	call   8010035c <panic>
    exit();
801066cd:	e8 88 d7 ff ff       	call   80103e5a <exit>
801066d2:	e9 ac fe ff ff       	jmp    80106583 <trap+0x90>
  if(myproc() && myproc()->state == RUNNING &&
801066d7:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801066db:	0f 85 ba fe ff ff    	jne    8010659b <trap+0xa8>
    tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
801066e1:	8b 0d 00 6d 11 80    	mov    0x80116d00,%ecx
801066e7:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801066ec:	89 c8                	mov    %ecx,%eax
801066ee:	f7 e2                	mul    %edx
801066f0:	c1 ea 03             	shr    $0x3,%edx
801066f3:	8d 04 92             	lea    (%edx,%edx,4),%eax
801066f6:	01 c0                	add    %eax,%eax
801066f8:	39 c1                	cmp    %eax,%ecx
801066fa:	0f 85 9b fe ff ff    	jne    8010659b <trap+0xa8>
    yield();
80106700:	e8 f5 d8 ff ff       	call   80103ffa <yield>
80106705:	e9 91 fe ff ff       	jmp    8010659b <trap+0xa8>
    exit();
8010670a:	e8 4b d7 ff ff       	call   80103e5a <exit>
8010670f:	e9 ac fe ff ff       	jmp    801065c0 <trap+0xcd>

80106714 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106714:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106718:	83 3d 80 dd 10 80 00 	cmpl   $0x0,0x8010dd80
8010671f:	74 14                	je     80106735 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106721:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106726:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106727:	a8 01                	test   $0x1,%al
80106729:	74 10                	je     8010673b <uartgetc+0x27>
8010672b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106730:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106731:	0f b6 c0             	movzbl %al,%eax
80106734:	c3                   	ret    
    return -1;
80106735:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010673a:	c3                   	ret    
    return -1;
8010673b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106740:	c3                   	ret    

80106741 <uartputc>:
{
80106741:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106745:	83 3d 80 dd 10 80 00 	cmpl   $0x0,0x8010dd80
8010674c:	74 3b                	je     80106789 <uartputc+0x48>
{
8010674e:	55                   	push   %ebp
8010674f:	89 e5                	mov    %esp,%ebp
80106751:	53                   	push   %ebx
80106752:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106755:	bb 00 00 00 00       	mov    $0x0,%ebx
8010675a:	83 fb 7f             	cmp    $0x7f,%ebx
8010675d:	7f 1c                	jg     8010677b <uartputc+0x3a>
8010675f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106764:	ec                   	in     (%dx),%al
80106765:	a8 20                	test   $0x20,%al
80106767:	75 12                	jne    8010677b <uartputc+0x3a>
    microdelay(10);
80106769:	83 ec 0c             	sub    $0xc,%esp
8010676c:	6a 0a                	push   $0xa
8010676e:	e8 96 bd ff ff       	call   80102509 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106773:	83 c3 01             	add    $0x1,%ebx
80106776:	83 c4 10             	add    $0x10,%esp
80106779:	eb df                	jmp    8010675a <uartputc+0x19>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010677b:	8b 45 08             	mov    0x8(%ebp),%eax
8010677e:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106783:	ee                   	out    %al,(%dx)
}
80106784:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106787:	c9                   	leave  
80106788:	c3                   	ret    
80106789:	c3                   	ret    

8010678a <uartinit>:
{
8010678a:	f3 0f 1e fb          	endbr32 
8010678e:	55                   	push   %ebp
8010678f:	89 e5                	mov    %esp,%ebp
80106791:	56                   	push   %esi
80106792:	53                   	push   %ebx
80106793:	b9 00 00 00 00       	mov    $0x0,%ecx
80106798:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010679d:	89 c8                	mov    %ecx,%eax
8010679f:	ee                   	out    %al,(%dx)
801067a0:	be fb 03 00 00       	mov    $0x3fb,%esi
801067a5:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801067aa:	89 f2                	mov    %esi,%edx
801067ac:	ee                   	out    %al,(%dx)
801067ad:	b8 0c 00 00 00       	mov    $0xc,%eax
801067b2:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067b7:	ee                   	out    %al,(%dx)
801067b8:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801067bd:	89 c8                	mov    %ecx,%eax
801067bf:	89 da                	mov    %ebx,%edx
801067c1:	ee                   	out    %al,(%dx)
801067c2:	b8 03 00 00 00       	mov    $0x3,%eax
801067c7:	89 f2                	mov    %esi,%edx
801067c9:	ee                   	out    %al,(%dx)
801067ca:	ba fc 03 00 00       	mov    $0x3fc,%edx
801067cf:	89 c8                	mov    %ecx,%eax
801067d1:	ee                   	out    %al,(%dx)
801067d2:	b8 01 00 00 00       	mov    $0x1,%eax
801067d7:	89 da                	mov    %ebx,%edx
801067d9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067da:	ba fd 03 00 00       	mov    $0x3fd,%edx
801067df:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801067e0:	3c ff                	cmp    $0xff,%al
801067e2:	74 45                	je     80106829 <uartinit+0x9f>
  uart = 1;
801067e4:	c7 05 80 dd 10 80 01 	movl   $0x1,0x8010dd80
801067eb:	00 00 00 
801067ee:	ba fa 03 00 00       	mov    $0x3fa,%edx
801067f3:	ec                   	in     (%dx),%al
801067f4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801067f9:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801067fa:	83 ec 08             	sub    $0x8,%esp
801067fd:	6a 00                	push   $0x0
801067ff:	6a 04                	push   $0x4
80106801:	e8 a6 b8 ff ff       	call   801020ac <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106806:	83 c4 10             	add    $0x10,%esp
80106809:	bb c4 8b 10 80       	mov    $0x80108bc4,%ebx
8010680e:	eb 12                	jmp    80106822 <uartinit+0x98>
    uartputc(*p);
80106810:	83 ec 0c             	sub    $0xc,%esp
80106813:	0f be c0             	movsbl %al,%eax
80106816:	50                   	push   %eax
80106817:	e8 25 ff ff ff       	call   80106741 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010681c:	83 c3 01             	add    $0x1,%ebx
8010681f:	83 c4 10             	add    $0x10,%esp
80106822:	0f b6 03             	movzbl (%ebx),%eax
80106825:	84 c0                	test   %al,%al
80106827:	75 e7                	jne    80106810 <uartinit+0x86>
}
80106829:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010682c:	5b                   	pop    %ebx
8010682d:	5e                   	pop    %esi
8010682e:	5d                   	pop    %ebp
8010682f:	c3                   	ret    

80106830 <uartintr>:

void
uartintr(void)
{
80106830:	f3 0f 1e fb          	endbr32 
80106834:	55                   	push   %ebp
80106835:	89 e5                	mov    %esp,%ebp
80106837:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010683a:	68 14 67 10 80       	push   $0x80106714
8010683f:	e8 3a 9f ff ff       	call   8010077e <consoleintr>
}
80106844:	83 c4 10             	add    $0x10,%esp
80106847:	c9                   	leave  
80106848:	c3                   	ret    

80106849 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106849:	6a 00                	push   $0x0
  pushl $0
8010684b:	6a 00                	push   $0x0
  jmp alltraps
8010684d:	e9 bd fb ff ff       	jmp    8010640f <alltraps>

80106852 <vector1>:
.globl vector1
vector1:
  pushl $0
80106852:	6a 00                	push   $0x0
  pushl $1
80106854:	6a 01                	push   $0x1
  jmp alltraps
80106856:	e9 b4 fb ff ff       	jmp    8010640f <alltraps>

8010685b <vector2>:
.globl vector2
vector2:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $2
8010685d:	6a 02                	push   $0x2
  jmp alltraps
8010685f:	e9 ab fb ff ff       	jmp    8010640f <alltraps>

80106864 <vector3>:
.globl vector3
vector3:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $3
80106866:	6a 03                	push   $0x3
  jmp alltraps
80106868:	e9 a2 fb ff ff       	jmp    8010640f <alltraps>

8010686d <vector4>:
.globl vector4
vector4:
  pushl $0
8010686d:	6a 00                	push   $0x0
  pushl $4
8010686f:	6a 04                	push   $0x4
  jmp alltraps
80106871:	e9 99 fb ff ff       	jmp    8010640f <alltraps>

80106876 <vector5>:
.globl vector5
vector5:
  pushl $0
80106876:	6a 00                	push   $0x0
  pushl $5
80106878:	6a 05                	push   $0x5
  jmp alltraps
8010687a:	e9 90 fb ff ff       	jmp    8010640f <alltraps>

8010687f <vector6>:
.globl vector6
vector6:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $6
80106881:	6a 06                	push   $0x6
  jmp alltraps
80106883:	e9 87 fb ff ff       	jmp    8010640f <alltraps>

80106888 <vector7>:
.globl vector7
vector7:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $7
8010688a:	6a 07                	push   $0x7
  jmp alltraps
8010688c:	e9 7e fb ff ff       	jmp    8010640f <alltraps>

80106891 <vector8>:
.globl vector8
vector8:
  pushl $8
80106891:	6a 08                	push   $0x8
  jmp alltraps
80106893:	e9 77 fb ff ff       	jmp    8010640f <alltraps>

80106898 <vector9>:
.globl vector9
vector9:
  pushl $0
80106898:	6a 00                	push   $0x0
  pushl $9
8010689a:	6a 09                	push   $0x9
  jmp alltraps
8010689c:	e9 6e fb ff ff       	jmp    8010640f <alltraps>

801068a1 <vector10>:
.globl vector10
vector10:
  pushl $10
801068a1:	6a 0a                	push   $0xa
  jmp alltraps
801068a3:	e9 67 fb ff ff       	jmp    8010640f <alltraps>

801068a8 <vector11>:
.globl vector11
vector11:
  pushl $11
801068a8:	6a 0b                	push   $0xb
  jmp alltraps
801068aa:	e9 60 fb ff ff       	jmp    8010640f <alltraps>

801068af <vector12>:
.globl vector12
vector12:
  pushl $12
801068af:	6a 0c                	push   $0xc
  jmp alltraps
801068b1:	e9 59 fb ff ff       	jmp    8010640f <alltraps>

801068b6 <vector13>:
.globl vector13
vector13:
  pushl $13
801068b6:	6a 0d                	push   $0xd
  jmp alltraps
801068b8:	e9 52 fb ff ff       	jmp    8010640f <alltraps>

801068bd <vector14>:
.globl vector14
vector14:
  pushl $14
801068bd:	6a 0e                	push   $0xe
  jmp alltraps
801068bf:	e9 4b fb ff ff       	jmp    8010640f <alltraps>

801068c4 <vector15>:
.globl vector15
vector15:
  pushl $0
801068c4:	6a 00                	push   $0x0
  pushl $15
801068c6:	6a 0f                	push   $0xf
  jmp alltraps
801068c8:	e9 42 fb ff ff       	jmp    8010640f <alltraps>

801068cd <vector16>:
.globl vector16
vector16:
  pushl $0
801068cd:	6a 00                	push   $0x0
  pushl $16
801068cf:	6a 10                	push   $0x10
  jmp alltraps
801068d1:	e9 39 fb ff ff       	jmp    8010640f <alltraps>

801068d6 <vector17>:
.globl vector17
vector17:
  pushl $17
801068d6:	6a 11                	push   $0x11
  jmp alltraps
801068d8:	e9 32 fb ff ff       	jmp    8010640f <alltraps>

801068dd <vector18>:
.globl vector18
vector18:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $18
801068df:	6a 12                	push   $0x12
  jmp alltraps
801068e1:	e9 29 fb ff ff       	jmp    8010640f <alltraps>

801068e6 <vector19>:
.globl vector19
vector19:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $19
801068e8:	6a 13                	push   $0x13
  jmp alltraps
801068ea:	e9 20 fb ff ff       	jmp    8010640f <alltraps>

801068ef <vector20>:
.globl vector20
vector20:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $20
801068f1:	6a 14                	push   $0x14
  jmp alltraps
801068f3:	e9 17 fb ff ff       	jmp    8010640f <alltraps>

801068f8 <vector21>:
.globl vector21
vector21:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $21
801068fa:	6a 15                	push   $0x15
  jmp alltraps
801068fc:	e9 0e fb ff ff       	jmp    8010640f <alltraps>

80106901 <vector22>:
.globl vector22
vector22:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $22
80106903:	6a 16                	push   $0x16
  jmp alltraps
80106905:	e9 05 fb ff ff       	jmp    8010640f <alltraps>

8010690a <vector23>:
.globl vector23
vector23:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $23
8010690c:	6a 17                	push   $0x17
  jmp alltraps
8010690e:	e9 fc fa ff ff       	jmp    8010640f <alltraps>

80106913 <vector24>:
.globl vector24
vector24:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $24
80106915:	6a 18                	push   $0x18
  jmp alltraps
80106917:	e9 f3 fa ff ff       	jmp    8010640f <alltraps>

8010691c <vector25>:
.globl vector25
vector25:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $25
8010691e:	6a 19                	push   $0x19
  jmp alltraps
80106920:	e9 ea fa ff ff       	jmp    8010640f <alltraps>

80106925 <vector26>:
.globl vector26
vector26:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $26
80106927:	6a 1a                	push   $0x1a
  jmp alltraps
80106929:	e9 e1 fa ff ff       	jmp    8010640f <alltraps>

8010692e <vector27>:
.globl vector27
vector27:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $27
80106930:	6a 1b                	push   $0x1b
  jmp alltraps
80106932:	e9 d8 fa ff ff       	jmp    8010640f <alltraps>

80106937 <vector28>:
.globl vector28
vector28:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $28
80106939:	6a 1c                	push   $0x1c
  jmp alltraps
8010693b:	e9 cf fa ff ff       	jmp    8010640f <alltraps>

80106940 <vector29>:
.globl vector29
vector29:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $29
80106942:	6a 1d                	push   $0x1d
  jmp alltraps
80106944:	e9 c6 fa ff ff       	jmp    8010640f <alltraps>

80106949 <vector30>:
.globl vector30
vector30:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $30
8010694b:	6a 1e                	push   $0x1e
  jmp alltraps
8010694d:	e9 bd fa ff ff       	jmp    8010640f <alltraps>

80106952 <vector31>:
.globl vector31
vector31:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $31
80106954:	6a 1f                	push   $0x1f
  jmp alltraps
80106956:	e9 b4 fa ff ff       	jmp    8010640f <alltraps>

8010695b <vector32>:
.globl vector32
vector32:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $32
8010695d:	6a 20                	push   $0x20
  jmp alltraps
8010695f:	e9 ab fa ff ff       	jmp    8010640f <alltraps>

80106964 <vector33>:
.globl vector33
vector33:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $33
80106966:	6a 21                	push   $0x21
  jmp alltraps
80106968:	e9 a2 fa ff ff       	jmp    8010640f <alltraps>

8010696d <vector34>:
.globl vector34
vector34:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $34
8010696f:	6a 22                	push   $0x22
  jmp alltraps
80106971:	e9 99 fa ff ff       	jmp    8010640f <alltraps>

80106976 <vector35>:
.globl vector35
vector35:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $35
80106978:	6a 23                	push   $0x23
  jmp alltraps
8010697a:	e9 90 fa ff ff       	jmp    8010640f <alltraps>

8010697f <vector36>:
.globl vector36
vector36:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $36
80106981:	6a 24                	push   $0x24
  jmp alltraps
80106983:	e9 87 fa ff ff       	jmp    8010640f <alltraps>

80106988 <vector37>:
.globl vector37
vector37:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $37
8010698a:	6a 25                	push   $0x25
  jmp alltraps
8010698c:	e9 7e fa ff ff       	jmp    8010640f <alltraps>

80106991 <vector38>:
.globl vector38
vector38:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $38
80106993:	6a 26                	push   $0x26
  jmp alltraps
80106995:	e9 75 fa ff ff       	jmp    8010640f <alltraps>

8010699a <vector39>:
.globl vector39
vector39:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $39
8010699c:	6a 27                	push   $0x27
  jmp alltraps
8010699e:	e9 6c fa ff ff       	jmp    8010640f <alltraps>

801069a3 <vector40>:
.globl vector40
vector40:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $40
801069a5:	6a 28                	push   $0x28
  jmp alltraps
801069a7:	e9 63 fa ff ff       	jmp    8010640f <alltraps>

801069ac <vector41>:
.globl vector41
vector41:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $41
801069ae:	6a 29                	push   $0x29
  jmp alltraps
801069b0:	e9 5a fa ff ff       	jmp    8010640f <alltraps>

801069b5 <vector42>:
.globl vector42
vector42:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $42
801069b7:	6a 2a                	push   $0x2a
  jmp alltraps
801069b9:	e9 51 fa ff ff       	jmp    8010640f <alltraps>

801069be <vector43>:
.globl vector43
vector43:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $43
801069c0:	6a 2b                	push   $0x2b
  jmp alltraps
801069c2:	e9 48 fa ff ff       	jmp    8010640f <alltraps>

801069c7 <vector44>:
.globl vector44
vector44:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $44
801069c9:	6a 2c                	push   $0x2c
  jmp alltraps
801069cb:	e9 3f fa ff ff       	jmp    8010640f <alltraps>

801069d0 <vector45>:
.globl vector45
vector45:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $45
801069d2:	6a 2d                	push   $0x2d
  jmp alltraps
801069d4:	e9 36 fa ff ff       	jmp    8010640f <alltraps>

801069d9 <vector46>:
.globl vector46
vector46:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $46
801069db:	6a 2e                	push   $0x2e
  jmp alltraps
801069dd:	e9 2d fa ff ff       	jmp    8010640f <alltraps>

801069e2 <vector47>:
.globl vector47
vector47:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $47
801069e4:	6a 2f                	push   $0x2f
  jmp alltraps
801069e6:	e9 24 fa ff ff       	jmp    8010640f <alltraps>

801069eb <vector48>:
.globl vector48
vector48:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $48
801069ed:	6a 30                	push   $0x30
  jmp alltraps
801069ef:	e9 1b fa ff ff       	jmp    8010640f <alltraps>

801069f4 <vector49>:
.globl vector49
vector49:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $49
801069f6:	6a 31                	push   $0x31
  jmp alltraps
801069f8:	e9 12 fa ff ff       	jmp    8010640f <alltraps>

801069fd <vector50>:
.globl vector50
vector50:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $50
801069ff:	6a 32                	push   $0x32
  jmp alltraps
80106a01:	e9 09 fa ff ff       	jmp    8010640f <alltraps>

80106a06 <vector51>:
.globl vector51
vector51:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $51
80106a08:	6a 33                	push   $0x33
  jmp alltraps
80106a0a:	e9 00 fa ff ff       	jmp    8010640f <alltraps>

80106a0f <vector52>:
.globl vector52
vector52:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $52
80106a11:	6a 34                	push   $0x34
  jmp alltraps
80106a13:	e9 f7 f9 ff ff       	jmp    8010640f <alltraps>

80106a18 <vector53>:
.globl vector53
vector53:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $53
80106a1a:	6a 35                	push   $0x35
  jmp alltraps
80106a1c:	e9 ee f9 ff ff       	jmp    8010640f <alltraps>

80106a21 <vector54>:
.globl vector54
vector54:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $54
80106a23:	6a 36                	push   $0x36
  jmp alltraps
80106a25:	e9 e5 f9 ff ff       	jmp    8010640f <alltraps>

80106a2a <vector55>:
.globl vector55
vector55:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $55
80106a2c:	6a 37                	push   $0x37
  jmp alltraps
80106a2e:	e9 dc f9 ff ff       	jmp    8010640f <alltraps>

80106a33 <vector56>:
.globl vector56
vector56:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $56
80106a35:	6a 38                	push   $0x38
  jmp alltraps
80106a37:	e9 d3 f9 ff ff       	jmp    8010640f <alltraps>

80106a3c <vector57>:
.globl vector57
vector57:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $57
80106a3e:	6a 39                	push   $0x39
  jmp alltraps
80106a40:	e9 ca f9 ff ff       	jmp    8010640f <alltraps>

80106a45 <vector58>:
.globl vector58
vector58:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $58
80106a47:	6a 3a                	push   $0x3a
  jmp alltraps
80106a49:	e9 c1 f9 ff ff       	jmp    8010640f <alltraps>

80106a4e <vector59>:
.globl vector59
vector59:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $59
80106a50:	6a 3b                	push   $0x3b
  jmp alltraps
80106a52:	e9 b8 f9 ff ff       	jmp    8010640f <alltraps>

80106a57 <vector60>:
.globl vector60
vector60:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $60
80106a59:	6a 3c                	push   $0x3c
  jmp alltraps
80106a5b:	e9 af f9 ff ff       	jmp    8010640f <alltraps>

80106a60 <vector61>:
.globl vector61
vector61:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $61
80106a62:	6a 3d                	push   $0x3d
  jmp alltraps
80106a64:	e9 a6 f9 ff ff       	jmp    8010640f <alltraps>

80106a69 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $62
80106a6b:	6a 3e                	push   $0x3e
  jmp alltraps
80106a6d:	e9 9d f9 ff ff       	jmp    8010640f <alltraps>

80106a72 <vector63>:
.globl vector63
vector63:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $63
80106a74:	6a 3f                	push   $0x3f
  jmp alltraps
80106a76:	e9 94 f9 ff ff       	jmp    8010640f <alltraps>

80106a7b <vector64>:
.globl vector64
vector64:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $64
80106a7d:	6a 40                	push   $0x40
  jmp alltraps
80106a7f:	e9 8b f9 ff ff       	jmp    8010640f <alltraps>

80106a84 <vector65>:
.globl vector65
vector65:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $65
80106a86:	6a 41                	push   $0x41
  jmp alltraps
80106a88:	e9 82 f9 ff ff       	jmp    8010640f <alltraps>

80106a8d <vector66>:
.globl vector66
vector66:
  pushl $0
80106a8d:	6a 00                	push   $0x0
  pushl $66
80106a8f:	6a 42                	push   $0x42
  jmp alltraps
80106a91:	e9 79 f9 ff ff       	jmp    8010640f <alltraps>

80106a96 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a96:	6a 00                	push   $0x0
  pushl $67
80106a98:	6a 43                	push   $0x43
  jmp alltraps
80106a9a:	e9 70 f9 ff ff       	jmp    8010640f <alltraps>

80106a9f <vector68>:
.globl vector68
vector68:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $68
80106aa1:	6a 44                	push   $0x44
  jmp alltraps
80106aa3:	e9 67 f9 ff ff       	jmp    8010640f <alltraps>

80106aa8 <vector69>:
.globl vector69
vector69:
  pushl $0
80106aa8:	6a 00                	push   $0x0
  pushl $69
80106aaa:	6a 45                	push   $0x45
  jmp alltraps
80106aac:	e9 5e f9 ff ff       	jmp    8010640f <alltraps>

80106ab1 <vector70>:
.globl vector70
vector70:
  pushl $0
80106ab1:	6a 00                	push   $0x0
  pushl $70
80106ab3:	6a 46                	push   $0x46
  jmp alltraps
80106ab5:	e9 55 f9 ff ff       	jmp    8010640f <alltraps>

80106aba <vector71>:
.globl vector71
vector71:
  pushl $0
80106aba:	6a 00                	push   $0x0
  pushl $71
80106abc:	6a 47                	push   $0x47
  jmp alltraps
80106abe:	e9 4c f9 ff ff       	jmp    8010640f <alltraps>

80106ac3 <vector72>:
.globl vector72
vector72:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $72
80106ac5:	6a 48                	push   $0x48
  jmp alltraps
80106ac7:	e9 43 f9 ff ff       	jmp    8010640f <alltraps>

80106acc <vector73>:
.globl vector73
vector73:
  pushl $0
80106acc:	6a 00                	push   $0x0
  pushl $73
80106ace:	6a 49                	push   $0x49
  jmp alltraps
80106ad0:	e9 3a f9 ff ff       	jmp    8010640f <alltraps>

80106ad5 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ad5:	6a 00                	push   $0x0
  pushl $74
80106ad7:	6a 4a                	push   $0x4a
  jmp alltraps
80106ad9:	e9 31 f9 ff ff       	jmp    8010640f <alltraps>

80106ade <vector75>:
.globl vector75
vector75:
  pushl $0
80106ade:	6a 00                	push   $0x0
  pushl $75
80106ae0:	6a 4b                	push   $0x4b
  jmp alltraps
80106ae2:	e9 28 f9 ff ff       	jmp    8010640f <alltraps>

80106ae7 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $76
80106ae9:	6a 4c                	push   $0x4c
  jmp alltraps
80106aeb:	e9 1f f9 ff ff       	jmp    8010640f <alltraps>

80106af0 <vector77>:
.globl vector77
vector77:
  pushl $0
80106af0:	6a 00                	push   $0x0
  pushl $77
80106af2:	6a 4d                	push   $0x4d
  jmp alltraps
80106af4:	e9 16 f9 ff ff       	jmp    8010640f <alltraps>

80106af9 <vector78>:
.globl vector78
vector78:
  pushl $0
80106af9:	6a 00                	push   $0x0
  pushl $78
80106afb:	6a 4e                	push   $0x4e
  jmp alltraps
80106afd:	e9 0d f9 ff ff       	jmp    8010640f <alltraps>

80106b02 <vector79>:
.globl vector79
vector79:
  pushl $0
80106b02:	6a 00                	push   $0x0
  pushl $79
80106b04:	6a 4f                	push   $0x4f
  jmp alltraps
80106b06:	e9 04 f9 ff ff       	jmp    8010640f <alltraps>

80106b0b <vector80>:
.globl vector80
vector80:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $80
80106b0d:	6a 50                	push   $0x50
  jmp alltraps
80106b0f:	e9 fb f8 ff ff       	jmp    8010640f <alltraps>

80106b14 <vector81>:
.globl vector81
vector81:
  pushl $0
80106b14:	6a 00                	push   $0x0
  pushl $81
80106b16:	6a 51                	push   $0x51
  jmp alltraps
80106b18:	e9 f2 f8 ff ff       	jmp    8010640f <alltraps>

80106b1d <vector82>:
.globl vector82
vector82:
  pushl $0
80106b1d:	6a 00                	push   $0x0
  pushl $82
80106b1f:	6a 52                	push   $0x52
  jmp alltraps
80106b21:	e9 e9 f8 ff ff       	jmp    8010640f <alltraps>

80106b26 <vector83>:
.globl vector83
vector83:
  pushl $0
80106b26:	6a 00                	push   $0x0
  pushl $83
80106b28:	6a 53                	push   $0x53
  jmp alltraps
80106b2a:	e9 e0 f8 ff ff       	jmp    8010640f <alltraps>

80106b2f <vector84>:
.globl vector84
vector84:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $84
80106b31:	6a 54                	push   $0x54
  jmp alltraps
80106b33:	e9 d7 f8 ff ff       	jmp    8010640f <alltraps>

80106b38 <vector85>:
.globl vector85
vector85:
  pushl $0
80106b38:	6a 00                	push   $0x0
  pushl $85
80106b3a:	6a 55                	push   $0x55
  jmp alltraps
80106b3c:	e9 ce f8 ff ff       	jmp    8010640f <alltraps>

80106b41 <vector86>:
.globl vector86
vector86:
  pushl $0
80106b41:	6a 00                	push   $0x0
  pushl $86
80106b43:	6a 56                	push   $0x56
  jmp alltraps
80106b45:	e9 c5 f8 ff ff       	jmp    8010640f <alltraps>

80106b4a <vector87>:
.globl vector87
vector87:
  pushl $0
80106b4a:	6a 00                	push   $0x0
  pushl $87
80106b4c:	6a 57                	push   $0x57
  jmp alltraps
80106b4e:	e9 bc f8 ff ff       	jmp    8010640f <alltraps>

80106b53 <vector88>:
.globl vector88
vector88:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $88
80106b55:	6a 58                	push   $0x58
  jmp alltraps
80106b57:	e9 b3 f8 ff ff       	jmp    8010640f <alltraps>

80106b5c <vector89>:
.globl vector89
vector89:
  pushl $0
80106b5c:	6a 00                	push   $0x0
  pushl $89
80106b5e:	6a 59                	push   $0x59
  jmp alltraps
80106b60:	e9 aa f8 ff ff       	jmp    8010640f <alltraps>

80106b65 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b65:	6a 00                	push   $0x0
  pushl $90
80106b67:	6a 5a                	push   $0x5a
  jmp alltraps
80106b69:	e9 a1 f8 ff ff       	jmp    8010640f <alltraps>

80106b6e <vector91>:
.globl vector91
vector91:
  pushl $0
80106b6e:	6a 00                	push   $0x0
  pushl $91
80106b70:	6a 5b                	push   $0x5b
  jmp alltraps
80106b72:	e9 98 f8 ff ff       	jmp    8010640f <alltraps>

80106b77 <vector92>:
.globl vector92
vector92:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $92
80106b79:	6a 5c                	push   $0x5c
  jmp alltraps
80106b7b:	e9 8f f8 ff ff       	jmp    8010640f <alltraps>

80106b80 <vector93>:
.globl vector93
vector93:
  pushl $0
80106b80:	6a 00                	push   $0x0
  pushl $93
80106b82:	6a 5d                	push   $0x5d
  jmp alltraps
80106b84:	e9 86 f8 ff ff       	jmp    8010640f <alltraps>

80106b89 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b89:	6a 00                	push   $0x0
  pushl $94
80106b8b:	6a 5e                	push   $0x5e
  jmp alltraps
80106b8d:	e9 7d f8 ff ff       	jmp    8010640f <alltraps>

80106b92 <vector95>:
.globl vector95
vector95:
  pushl $0
80106b92:	6a 00                	push   $0x0
  pushl $95
80106b94:	6a 5f                	push   $0x5f
  jmp alltraps
80106b96:	e9 74 f8 ff ff       	jmp    8010640f <alltraps>

80106b9b <vector96>:
.globl vector96
vector96:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $96
80106b9d:	6a 60                	push   $0x60
  jmp alltraps
80106b9f:	e9 6b f8 ff ff       	jmp    8010640f <alltraps>

80106ba4 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ba4:	6a 00                	push   $0x0
  pushl $97
80106ba6:	6a 61                	push   $0x61
  jmp alltraps
80106ba8:	e9 62 f8 ff ff       	jmp    8010640f <alltraps>

80106bad <vector98>:
.globl vector98
vector98:
  pushl $0
80106bad:	6a 00                	push   $0x0
  pushl $98
80106baf:	6a 62                	push   $0x62
  jmp alltraps
80106bb1:	e9 59 f8 ff ff       	jmp    8010640f <alltraps>

80106bb6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106bb6:	6a 00                	push   $0x0
  pushl $99
80106bb8:	6a 63                	push   $0x63
  jmp alltraps
80106bba:	e9 50 f8 ff ff       	jmp    8010640f <alltraps>

80106bbf <vector100>:
.globl vector100
vector100:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $100
80106bc1:	6a 64                	push   $0x64
  jmp alltraps
80106bc3:	e9 47 f8 ff ff       	jmp    8010640f <alltraps>

80106bc8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106bc8:	6a 00                	push   $0x0
  pushl $101
80106bca:	6a 65                	push   $0x65
  jmp alltraps
80106bcc:	e9 3e f8 ff ff       	jmp    8010640f <alltraps>

80106bd1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106bd1:	6a 00                	push   $0x0
  pushl $102
80106bd3:	6a 66                	push   $0x66
  jmp alltraps
80106bd5:	e9 35 f8 ff ff       	jmp    8010640f <alltraps>

80106bda <vector103>:
.globl vector103
vector103:
  pushl $0
80106bda:	6a 00                	push   $0x0
  pushl $103
80106bdc:	6a 67                	push   $0x67
  jmp alltraps
80106bde:	e9 2c f8 ff ff       	jmp    8010640f <alltraps>

80106be3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $104
80106be5:	6a 68                	push   $0x68
  jmp alltraps
80106be7:	e9 23 f8 ff ff       	jmp    8010640f <alltraps>

80106bec <vector105>:
.globl vector105
vector105:
  pushl $0
80106bec:	6a 00                	push   $0x0
  pushl $105
80106bee:	6a 69                	push   $0x69
  jmp alltraps
80106bf0:	e9 1a f8 ff ff       	jmp    8010640f <alltraps>

80106bf5 <vector106>:
.globl vector106
vector106:
  pushl $0
80106bf5:	6a 00                	push   $0x0
  pushl $106
80106bf7:	6a 6a                	push   $0x6a
  jmp alltraps
80106bf9:	e9 11 f8 ff ff       	jmp    8010640f <alltraps>

80106bfe <vector107>:
.globl vector107
vector107:
  pushl $0
80106bfe:	6a 00                	push   $0x0
  pushl $107
80106c00:	6a 6b                	push   $0x6b
  jmp alltraps
80106c02:	e9 08 f8 ff ff       	jmp    8010640f <alltraps>

80106c07 <vector108>:
.globl vector108
vector108:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $108
80106c09:	6a 6c                	push   $0x6c
  jmp alltraps
80106c0b:	e9 ff f7 ff ff       	jmp    8010640f <alltraps>

80106c10 <vector109>:
.globl vector109
vector109:
  pushl $0
80106c10:	6a 00                	push   $0x0
  pushl $109
80106c12:	6a 6d                	push   $0x6d
  jmp alltraps
80106c14:	e9 f6 f7 ff ff       	jmp    8010640f <alltraps>

80106c19 <vector110>:
.globl vector110
vector110:
  pushl $0
80106c19:	6a 00                	push   $0x0
  pushl $110
80106c1b:	6a 6e                	push   $0x6e
  jmp alltraps
80106c1d:	e9 ed f7 ff ff       	jmp    8010640f <alltraps>

80106c22 <vector111>:
.globl vector111
vector111:
  pushl $0
80106c22:	6a 00                	push   $0x0
  pushl $111
80106c24:	6a 6f                	push   $0x6f
  jmp alltraps
80106c26:	e9 e4 f7 ff ff       	jmp    8010640f <alltraps>

80106c2b <vector112>:
.globl vector112
vector112:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $112
80106c2d:	6a 70                	push   $0x70
  jmp alltraps
80106c2f:	e9 db f7 ff ff       	jmp    8010640f <alltraps>

80106c34 <vector113>:
.globl vector113
vector113:
  pushl $0
80106c34:	6a 00                	push   $0x0
  pushl $113
80106c36:	6a 71                	push   $0x71
  jmp alltraps
80106c38:	e9 d2 f7 ff ff       	jmp    8010640f <alltraps>

80106c3d <vector114>:
.globl vector114
vector114:
  pushl $0
80106c3d:	6a 00                	push   $0x0
  pushl $114
80106c3f:	6a 72                	push   $0x72
  jmp alltraps
80106c41:	e9 c9 f7 ff ff       	jmp    8010640f <alltraps>

80106c46 <vector115>:
.globl vector115
vector115:
  pushl $0
80106c46:	6a 00                	push   $0x0
  pushl $115
80106c48:	6a 73                	push   $0x73
  jmp alltraps
80106c4a:	e9 c0 f7 ff ff       	jmp    8010640f <alltraps>

80106c4f <vector116>:
.globl vector116
vector116:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $116
80106c51:	6a 74                	push   $0x74
  jmp alltraps
80106c53:	e9 b7 f7 ff ff       	jmp    8010640f <alltraps>

80106c58 <vector117>:
.globl vector117
vector117:
  pushl $0
80106c58:	6a 00                	push   $0x0
  pushl $117
80106c5a:	6a 75                	push   $0x75
  jmp alltraps
80106c5c:	e9 ae f7 ff ff       	jmp    8010640f <alltraps>

80106c61 <vector118>:
.globl vector118
vector118:
  pushl $0
80106c61:	6a 00                	push   $0x0
  pushl $118
80106c63:	6a 76                	push   $0x76
  jmp alltraps
80106c65:	e9 a5 f7 ff ff       	jmp    8010640f <alltraps>

80106c6a <vector119>:
.globl vector119
vector119:
  pushl $0
80106c6a:	6a 00                	push   $0x0
  pushl $119
80106c6c:	6a 77                	push   $0x77
  jmp alltraps
80106c6e:	e9 9c f7 ff ff       	jmp    8010640f <alltraps>

80106c73 <vector120>:
.globl vector120
vector120:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $120
80106c75:	6a 78                	push   $0x78
  jmp alltraps
80106c77:	e9 93 f7 ff ff       	jmp    8010640f <alltraps>

80106c7c <vector121>:
.globl vector121
vector121:
  pushl $0
80106c7c:	6a 00                	push   $0x0
  pushl $121
80106c7e:	6a 79                	push   $0x79
  jmp alltraps
80106c80:	e9 8a f7 ff ff       	jmp    8010640f <alltraps>

80106c85 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c85:	6a 00                	push   $0x0
  pushl $122
80106c87:	6a 7a                	push   $0x7a
  jmp alltraps
80106c89:	e9 81 f7 ff ff       	jmp    8010640f <alltraps>

80106c8e <vector123>:
.globl vector123
vector123:
  pushl $0
80106c8e:	6a 00                	push   $0x0
  pushl $123
80106c90:	6a 7b                	push   $0x7b
  jmp alltraps
80106c92:	e9 78 f7 ff ff       	jmp    8010640f <alltraps>

80106c97 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $124
80106c99:	6a 7c                	push   $0x7c
  jmp alltraps
80106c9b:	e9 6f f7 ff ff       	jmp    8010640f <alltraps>

80106ca0 <vector125>:
.globl vector125
vector125:
  pushl $0
80106ca0:	6a 00                	push   $0x0
  pushl $125
80106ca2:	6a 7d                	push   $0x7d
  jmp alltraps
80106ca4:	e9 66 f7 ff ff       	jmp    8010640f <alltraps>

80106ca9 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ca9:	6a 00                	push   $0x0
  pushl $126
80106cab:	6a 7e                	push   $0x7e
  jmp alltraps
80106cad:	e9 5d f7 ff ff       	jmp    8010640f <alltraps>

80106cb2 <vector127>:
.globl vector127
vector127:
  pushl $0
80106cb2:	6a 00                	push   $0x0
  pushl $127
80106cb4:	6a 7f                	push   $0x7f
  jmp alltraps
80106cb6:	e9 54 f7 ff ff       	jmp    8010640f <alltraps>

80106cbb <vector128>:
.globl vector128
vector128:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $128
80106cbd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106cc2:	e9 48 f7 ff ff       	jmp    8010640f <alltraps>

80106cc7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $129
80106cc9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106cce:	e9 3c f7 ff ff       	jmp    8010640f <alltraps>

80106cd3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $130
80106cd5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106cda:	e9 30 f7 ff ff       	jmp    8010640f <alltraps>

80106cdf <vector131>:
.globl vector131
vector131:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $131
80106ce1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ce6:	e9 24 f7 ff ff       	jmp    8010640f <alltraps>

80106ceb <vector132>:
.globl vector132
vector132:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $132
80106ced:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106cf2:	e9 18 f7 ff ff       	jmp    8010640f <alltraps>

80106cf7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $133
80106cf9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106cfe:	e9 0c f7 ff ff       	jmp    8010640f <alltraps>

80106d03 <vector134>:
.globl vector134
vector134:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $134
80106d05:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106d0a:	e9 00 f7 ff ff       	jmp    8010640f <alltraps>

80106d0f <vector135>:
.globl vector135
vector135:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $135
80106d11:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106d16:	e9 f4 f6 ff ff       	jmp    8010640f <alltraps>

80106d1b <vector136>:
.globl vector136
vector136:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $136
80106d1d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106d22:	e9 e8 f6 ff ff       	jmp    8010640f <alltraps>

80106d27 <vector137>:
.globl vector137
vector137:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $137
80106d29:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106d2e:	e9 dc f6 ff ff       	jmp    8010640f <alltraps>

80106d33 <vector138>:
.globl vector138
vector138:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $138
80106d35:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106d3a:	e9 d0 f6 ff ff       	jmp    8010640f <alltraps>

80106d3f <vector139>:
.globl vector139
vector139:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $139
80106d41:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106d46:	e9 c4 f6 ff ff       	jmp    8010640f <alltraps>

80106d4b <vector140>:
.globl vector140
vector140:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $140
80106d4d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106d52:	e9 b8 f6 ff ff       	jmp    8010640f <alltraps>

80106d57 <vector141>:
.globl vector141
vector141:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $141
80106d59:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106d5e:	e9 ac f6 ff ff       	jmp    8010640f <alltraps>

80106d63 <vector142>:
.globl vector142
vector142:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $142
80106d65:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d6a:	e9 a0 f6 ff ff       	jmp    8010640f <alltraps>

80106d6f <vector143>:
.globl vector143
vector143:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $143
80106d71:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106d76:	e9 94 f6 ff ff       	jmp    8010640f <alltraps>

80106d7b <vector144>:
.globl vector144
vector144:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $144
80106d7d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d82:	e9 88 f6 ff ff       	jmp    8010640f <alltraps>

80106d87 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $145
80106d89:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d8e:	e9 7c f6 ff ff       	jmp    8010640f <alltraps>

80106d93 <vector146>:
.globl vector146
vector146:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $146
80106d95:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d9a:	e9 70 f6 ff ff       	jmp    8010640f <alltraps>

80106d9f <vector147>:
.globl vector147
vector147:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $147
80106da1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106da6:	e9 64 f6 ff ff       	jmp    8010640f <alltraps>

80106dab <vector148>:
.globl vector148
vector148:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $148
80106dad:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106db2:	e9 58 f6 ff ff       	jmp    8010640f <alltraps>

80106db7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $149
80106db9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106dbe:	e9 4c f6 ff ff       	jmp    8010640f <alltraps>

80106dc3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $150
80106dc5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106dca:	e9 40 f6 ff ff       	jmp    8010640f <alltraps>

80106dcf <vector151>:
.globl vector151
vector151:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $151
80106dd1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106dd6:	e9 34 f6 ff ff       	jmp    8010640f <alltraps>

80106ddb <vector152>:
.globl vector152
vector152:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $152
80106ddd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106de2:	e9 28 f6 ff ff       	jmp    8010640f <alltraps>

80106de7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $153
80106de9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106dee:	e9 1c f6 ff ff       	jmp    8010640f <alltraps>

80106df3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $154
80106df5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106dfa:	e9 10 f6 ff ff       	jmp    8010640f <alltraps>

80106dff <vector155>:
.globl vector155
vector155:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $155
80106e01:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106e06:	e9 04 f6 ff ff       	jmp    8010640f <alltraps>

80106e0b <vector156>:
.globl vector156
vector156:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $156
80106e0d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106e12:	e9 f8 f5 ff ff       	jmp    8010640f <alltraps>

80106e17 <vector157>:
.globl vector157
vector157:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $157
80106e19:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106e1e:	e9 ec f5 ff ff       	jmp    8010640f <alltraps>

80106e23 <vector158>:
.globl vector158
vector158:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $158
80106e25:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106e2a:	e9 e0 f5 ff ff       	jmp    8010640f <alltraps>

80106e2f <vector159>:
.globl vector159
vector159:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $159
80106e31:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106e36:	e9 d4 f5 ff ff       	jmp    8010640f <alltraps>

80106e3b <vector160>:
.globl vector160
vector160:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $160
80106e3d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106e42:	e9 c8 f5 ff ff       	jmp    8010640f <alltraps>

80106e47 <vector161>:
.globl vector161
vector161:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $161
80106e49:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106e4e:	e9 bc f5 ff ff       	jmp    8010640f <alltraps>

80106e53 <vector162>:
.globl vector162
vector162:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $162
80106e55:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106e5a:	e9 b0 f5 ff ff       	jmp    8010640f <alltraps>

80106e5f <vector163>:
.globl vector163
vector163:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $163
80106e61:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e66:	e9 a4 f5 ff ff       	jmp    8010640f <alltraps>

80106e6b <vector164>:
.globl vector164
vector164:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $164
80106e6d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e72:	e9 98 f5 ff ff       	jmp    8010640f <alltraps>

80106e77 <vector165>:
.globl vector165
vector165:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $165
80106e79:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106e7e:	e9 8c f5 ff ff       	jmp    8010640f <alltraps>

80106e83 <vector166>:
.globl vector166
vector166:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $166
80106e85:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e8a:	e9 80 f5 ff ff       	jmp    8010640f <alltraps>

80106e8f <vector167>:
.globl vector167
vector167:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $167
80106e91:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e96:	e9 74 f5 ff ff       	jmp    8010640f <alltraps>

80106e9b <vector168>:
.globl vector168
vector168:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $168
80106e9d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106ea2:	e9 68 f5 ff ff       	jmp    8010640f <alltraps>

80106ea7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $169
80106ea9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106eae:	e9 5c f5 ff ff       	jmp    8010640f <alltraps>

80106eb3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $170
80106eb5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106eba:	e9 50 f5 ff ff       	jmp    8010640f <alltraps>

80106ebf <vector171>:
.globl vector171
vector171:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $171
80106ec1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ec6:	e9 44 f5 ff ff       	jmp    8010640f <alltraps>

80106ecb <vector172>:
.globl vector172
vector172:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $172
80106ecd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106ed2:	e9 38 f5 ff ff       	jmp    8010640f <alltraps>

80106ed7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $173
80106ed9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106ede:	e9 2c f5 ff ff       	jmp    8010640f <alltraps>

80106ee3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $174
80106ee5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106eea:	e9 20 f5 ff ff       	jmp    8010640f <alltraps>

80106eef <vector175>:
.globl vector175
vector175:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $175
80106ef1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ef6:	e9 14 f5 ff ff       	jmp    8010640f <alltraps>

80106efb <vector176>:
.globl vector176
vector176:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $176
80106efd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106f02:	e9 08 f5 ff ff       	jmp    8010640f <alltraps>

80106f07 <vector177>:
.globl vector177
vector177:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $177
80106f09:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106f0e:	e9 fc f4 ff ff       	jmp    8010640f <alltraps>

80106f13 <vector178>:
.globl vector178
vector178:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $178
80106f15:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106f1a:	e9 f0 f4 ff ff       	jmp    8010640f <alltraps>

80106f1f <vector179>:
.globl vector179
vector179:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $179
80106f21:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106f26:	e9 e4 f4 ff ff       	jmp    8010640f <alltraps>

80106f2b <vector180>:
.globl vector180
vector180:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $180
80106f2d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106f32:	e9 d8 f4 ff ff       	jmp    8010640f <alltraps>

80106f37 <vector181>:
.globl vector181
vector181:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $181
80106f39:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106f3e:	e9 cc f4 ff ff       	jmp    8010640f <alltraps>

80106f43 <vector182>:
.globl vector182
vector182:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $182
80106f45:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106f4a:	e9 c0 f4 ff ff       	jmp    8010640f <alltraps>

80106f4f <vector183>:
.globl vector183
vector183:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $183
80106f51:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106f56:	e9 b4 f4 ff ff       	jmp    8010640f <alltraps>

80106f5b <vector184>:
.globl vector184
vector184:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $184
80106f5d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f62:	e9 a8 f4 ff ff       	jmp    8010640f <alltraps>

80106f67 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $185
80106f69:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f6e:	e9 9c f4 ff ff       	jmp    8010640f <alltraps>

80106f73 <vector186>:
.globl vector186
vector186:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $186
80106f75:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106f7a:	e9 90 f4 ff ff       	jmp    8010640f <alltraps>

80106f7f <vector187>:
.globl vector187
vector187:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $187
80106f81:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f86:	e9 84 f4 ff ff       	jmp    8010640f <alltraps>

80106f8b <vector188>:
.globl vector188
vector188:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $188
80106f8d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f92:	e9 78 f4 ff ff       	jmp    8010640f <alltraps>

80106f97 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $189
80106f99:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f9e:	e9 6c f4 ff ff       	jmp    8010640f <alltraps>

80106fa3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $190
80106fa5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106faa:	e9 60 f4 ff ff       	jmp    8010640f <alltraps>

80106faf <vector191>:
.globl vector191
vector191:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $191
80106fb1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106fb6:	e9 54 f4 ff ff       	jmp    8010640f <alltraps>

80106fbb <vector192>:
.globl vector192
vector192:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $192
80106fbd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106fc2:	e9 48 f4 ff ff       	jmp    8010640f <alltraps>

80106fc7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $193
80106fc9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106fce:	e9 3c f4 ff ff       	jmp    8010640f <alltraps>

80106fd3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $194
80106fd5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106fda:	e9 30 f4 ff ff       	jmp    8010640f <alltraps>

80106fdf <vector195>:
.globl vector195
vector195:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $195
80106fe1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106fe6:	e9 24 f4 ff ff       	jmp    8010640f <alltraps>

80106feb <vector196>:
.globl vector196
vector196:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $196
80106fed:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106ff2:	e9 18 f4 ff ff       	jmp    8010640f <alltraps>

80106ff7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $197
80106ff9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106ffe:	e9 0c f4 ff ff       	jmp    8010640f <alltraps>

80107003 <vector198>:
.globl vector198
vector198:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $198
80107005:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010700a:	e9 00 f4 ff ff       	jmp    8010640f <alltraps>

8010700f <vector199>:
.globl vector199
vector199:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $199
80107011:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107016:	e9 f4 f3 ff ff       	jmp    8010640f <alltraps>

8010701b <vector200>:
.globl vector200
vector200:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $200
8010701d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107022:	e9 e8 f3 ff ff       	jmp    8010640f <alltraps>

80107027 <vector201>:
.globl vector201
vector201:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $201
80107029:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010702e:	e9 dc f3 ff ff       	jmp    8010640f <alltraps>

80107033 <vector202>:
.globl vector202
vector202:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $202
80107035:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010703a:	e9 d0 f3 ff ff       	jmp    8010640f <alltraps>

8010703f <vector203>:
.globl vector203
vector203:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $203
80107041:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107046:	e9 c4 f3 ff ff       	jmp    8010640f <alltraps>

8010704b <vector204>:
.globl vector204
vector204:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $204
8010704d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107052:	e9 b8 f3 ff ff       	jmp    8010640f <alltraps>

80107057 <vector205>:
.globl vector205
vector205:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $205
80107059:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010705e:	e9 ac f3 ff ff       	jmp    8010640f <alltraps>

80107063 <vector206>:
.globl vector206
vector206:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $206
80107065:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010706a:	e9 a0 f3 ff ff       	jmp    8010640f <alltraps>

8010706f <vector207>:
.globl vector207
vector207:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $207
80107071:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107076:	e9 94 f3 ff ff       	jmp    8010640f <alltraps>

8010707b <vector208>:
.globl vector208
vector208:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $208
8010707d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107082:	e9 88 f3 ff ff       	jmp    8010640f <alltraps>

80107087 <vector209>:
.globl vector209
vector209:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $209
80107089:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010708e:	e9 7c f3 ff ff       	jmp    8010640f <alltraps>

80107093 <vector210>:
.globl vector210
vector210:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $210
80107095:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010709a:	e9 70 f3 ff ff       	jmp    8010640f <alltraps>

8010709f <vector211>:
.globl vector211
vector211:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $211
801070a1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801070a6:	e9 64 f3 ff ff       	jmp    8010640f <alltraps>

801070ab <vector212>:
.globl vector212
vector212:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $212
801070ad:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801070b2:	e9 58 f3 ff ff       	jmp    8010640f <alltraps>

801070b7 <vector213>:
.globl vector213
vector213:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $213
801070b9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801070be:	e9 4c f3 ff ff       	jmp    8010640f <alltraps>

801070c3 <vector214>:
.globl vector214
vector214:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $214
801070c5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801070ca:	e9 40 f3 ff ff       	jmp    8010640f <alltraps>

801070cf <vector215>:
.globl vector215
vector215:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $215
801070d1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801070d6:	e9 34 f3 ff ff       	jmp    8010640f <alltraps>

801070db <vector216>:
.globl vector216
vector216:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $216
801070dd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801070e2:	e9 28 f3 ff ff       	jmp    8010640f <alltraps>

801070e7 <vector217>:
.globl vector217
vector217:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $217
801070e9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801070ee:	e9 1c f3 ff ff       	jmp    8010640f <alltraps>

801070f3 <vector218>:
.globl vector218
vector218:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $218
801070f5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801070fa:	e9 10 f3 ff ff       	jmp    8010640f <alltraps>

801070ff <vector219>:
.globl vector219
vector219:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $219
80107101:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107106:	e9 04 f3 ff ff       	jmp    8010640f <alltraps>

8010710b <vector220>:
.globl vector220
vector220:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $220
8010710d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107112:	e9 f8 f2 ff ff       	jmp    8010640f <alltraps>

80107117 <vector221>:
.globl vector221
vector221:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $221
80107119:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010711e:	e9 ec f2 ff ff       	jmp    8010640f <alltraps>

80107123 <vector222>:
.globl vector222
vector222:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $222
80107125:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010712a:	e9 e0 f2 ff ff       	jmp    8010640f <alltraps>

8010712f <vector223>:
.globl vector223
vector223:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $223
80107131:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107136:	e9 d4 f2 ff ff       	jmp    8010640f <alltraps>

8010713b <vector224>:
.globl vector224
vector224:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $224
8010713d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107142:	e9 c8 f2 ff ff       	jmp    8010640f <alltraps>

80107147 <vector225>:
.globl vector225
vector225:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $225
80107149:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010714e:	e9 bc f2 ff ff       	jmp    8010640f <alltraps>

80107153 <vector226>:
.globl vector226
vector226:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $226
80107155:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010715a:	e9 b0 f2 ff ff       	jmp    8010640f <alltraps>

8010715f <vector227>:
.globl vector227
vector227:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $227
80107161:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107166:	e9 a4 f2 ff ff       	jmp    8010640f <alltraps>

8010716b <vector228>:
.globl vector228
vector228:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $228
8010716d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107172:	e9 98 f2 ff ff       	jmp    8010640f <alltraps>

80107177 <vector229>:
.globl vector229
vector229:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $229
80107179:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010717e:	e9 8c f2 ff ff       	jmp    8010640f <alltraps>

80107183 <vector230>:
.globl vector230
vector230:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $230
80107185:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010718a:	e9 80 f2 ff ff       	jmp    8010640f <alltraps>

8010718f <vector231>:
.globl vector231
vector231:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $231
80107191:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107196:	e9 74 f2 ff ff       	jmp    8010640f <alltraps>

8010719b <vector232>:
.globl vector232
vector232:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $232
8010719d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801071a2:	e9 68 f2 ff ff       	jmp    8010640f <alltraps>

801071a7 <vector233>:
.globl vector233
vector233:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $233
801071a9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801071ae:	e9 5c f2 ff ff       	jmp    8010640f <alltraps>

801071b3 <vector234>:
.globl vector234
vector234:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $234
801071b5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801071ba:	e9 50 f2 ff ff       	jmp    8010640f <alltraps>

801071bf <vector235>:
.globl vector235
vector235:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $235
801071c1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801071c6:	e9 44 f2 ff ff       	jmp    8010640f <alltraps>

801071cb <vector236>:
.globl vector236
vector236:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $236
801071cd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801071d2:	e9 38 f2 ff ff       	jmp    8010640f <alltraps>

801071d7 <vector237>:
.globl vector237
vector237:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $237
801071d9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801071de:	e9 2c f2 ff ff       	jmp    8010640f <alltraps>

801071e3 <vector238>:
.globl vector238
vector238:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $238
801071e5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801071ea:	e9 20 f2 ff ff       	jmp    8010640f <alltraps>

801071ef <vector239>:
.globl vector239
vector239:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $239
801071f1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801071f6:	e9 14 f2 ff ff       	jmp    8010640f <alltraps>

801071fb <vector240>:
.globl vector240
vector240:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $240
801071fd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107202:	e9 08 f2 ff ff       	jmp    8010640f <alltraps>

80107207 <vector241>:
.globl vector241
vector241:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $241
80107209:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010720e:	e9 fc f1 ff ff       	jmp    8010640f <alltraps>

80107213 <vector242>:
.globl vector242
vector242:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $242
80107215:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010721a:	e9 f0 f1 ff ff       	jmp    8010640f <alltraps>

8010721f <vector243>:
.globl vector243
vector243:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $243
80107221:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107226:	e9 e4 f1 ff ff       	jmp    8010640f <alltraps>

8010722b <vector244>:
.globl vector244
vector244:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $244
8010722d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107232:	e9 d8 f1 ff ff       	jmp    8010640f <alltraps>

80107237 <vector245>:
.globl vector245
vector245:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $245
80107239:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010723e:	e9 cc f1 ff ff       	jmp    8010640f <alltraps>

80107243 <vector246>:
.globl vector246
vector246:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $246
80107245:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010724a:	e9 c0 f1 ff ff       	jmp    8010640f <alltraps>

8010724f <vector247>:
.globl vector247
vector247:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $247
80107251:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107256:	e9 b4 f1 ff ff       	jmp    8010640f <alltraps>

8010725b <vector248>:
.globl vector248
vector248:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $248
8010725d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107262:	e9 a8 f1 ff ff       	jmp    8010640f <alltraps>

80107267 <vector249>:
.globl vector249
vector249:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $249
80107269:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010726e:	e9 9c f1 ff ff       	jmp    8010640f <alltraps>

80107273 <vector250>:
.globl vector250
vector250:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $250
80107275:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010727a:	e9 90 f1 ff ff       	jmp    8010640f <alltraps>

8010727f <vector251>:
.globl vector251
vector251:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $251
80107281:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107286:	e9 84 f1 ff ff       	jmp    8010640f <alltraps>

8010728b <vector252>:
.globl vector252
vector252:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $252
8010728d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107292:	e9 78 f1 ff ff       	jmp    8010640f <alltraps>

80107297 <vector253>:
.globl vector253
vector253:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $253
80107299:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010729e:	e9 6c f1 ff ff       	jmp    8010640f <alltraps>

801072a3 <vector254>:
.globl vector254
vector254:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $254
801072a5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801072aa:	e9 60 f1 ff ff       	jmp    8010640f <alltraps>

801072af <vector255>:
.globl vector255
vector255:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $255
801072b1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801072b6:	e9 54 f1 ff ff       	jmp    8010640f <alltraps>

801072bb <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801072bb:	55                   	push   %ebp
801072bc:	89 e5                	mov    %esp,%ebp
801072be:	57                   	push   %edi
801072bf:	56                   	push   %esi
801072c0:	53                   	push   %ebx
801072c1:	83 ec 0c             	sub    $0xc,%esp
801072c4:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801072c6:	c1 ea 16             	shr    $0x16,%edx
801072c9:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
801072cc:	8b 37                	mov    (%edi),%esi
801072ce:	f7 c6 01 00 00 00    	test   $0x1,%esi
801072d4:	74 20                	je     801072f6 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072d6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801072dc:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801072e2:	c1 eb 0c             	shr    $0xc,%ebx
801072e5:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
801072eb:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
801072ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f1:	5b                   	pop    %ebx
801072f2:	5e                   	pop    %esi
801072f3:	5f                   	pop    %edi
801072f4:	5d                   	pop    %ebp
801072f5:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801072f6:	85 c9                	test   %ecx,%ecx
801072f8:	74 2b                	je     80107325 <walkpgdir+0x6a>
801072fa:	e8 04 af ff ff       	call   80102203 <kalloc>
801072ff:	89 c6                	mov    %eax,%esi
80107301:	85 c0                	test   %eax,%eax
80107303:	74 20                	je     80107325 <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80107305:	83 ec 04             	sub    $0x4,%esp
80107308:	68 00 10 00 00       	push   $0x1000
8010730d:	6a 00                	push   $0x0
8010730f:	50                   	push   %eax
80107310:	e8 3a de ff ff       	call   8010514f <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107315:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010731b:	83 c8 07             	or     $0x7,%eax
8010731e:	89 07                	mov    %eax,(%edi)
80107320:	83 c4 10             	add    $0x10,%esp
80107323:	eb bd                	jmp    801072e2 <walkpgdir+0x27>
      return 0;
80107325:	b8 00 00 00 00       	mov    $0x0,%eax
8010732a:	eb c2                	jmp    801072ee <walkpgdir+0x33>

8010732c <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010732c:	55                   	push   %ebp
8010732d:	89 e5                	mov    %esp,%ebp
8010732f:	57                   	push   %edi
80107330:	56                   	push   %esi
80107331:	53                   	push   %ebx
80107332:	83 ec 1c             	sub    $0x1c,%esp
80107335:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107338:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010733b:	89 d3                	mov    %edx,%ebx
8010733d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107343:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
80107347:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010734d:	b9 01 00 00 00       	mov    $0x1,%ecx
80107352:	89 da                	mov    %ebx,%edx
80107354:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107357:	e8 5f ff ff ff       	call   801072bb <walkpgdir>
8010735c:	85 c0                	test   %eax,%eax
8010735e:	74 2e                	je     8010738e <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80107360:	f6 00 01             	testb  $0x1,(%eax)
80107363:	75 1c                	jne    80107381 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107365:	89 f2                	mov    %esi,%edx
80107367:	0b 55 0c             	or     0xc(%ebp),%edx
8010736a:	83 ca 01             	or     $0x1,%edx
8010736d:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010736f:	39 fb                	cmp    %edi,%ebx
80107371:	74 28                	je     8010739b <mappages+0x6f>
      break;
    a += PGSIZE;
80107373:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80107379:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010737f:	eb cc                	jmp    8010734d <mappages+0x21>
      panic("remap");
80107381:	83 ec 0c             	sub    $0xc,%esp
80107384:	68 cc 8b 10 80       	push   $0x80108bcc
80107389:	e8 ce 8f ff ff       	call   8010035c <panic>
      return -1;
8010738e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107393:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107396:	5b                   	pop    %ebx
80107397:	5e                   	pop    %esi
80107398:	5f                   	pop    %edi
80107399:	5d                   	pop    %ebp
8010739a:	c3                   	ret    
  return 0;
8010739b:	b8 00 00 00 00       	mov    $0x0,%eax
801073a0:	eb f1                	jmp    80107393 <mappages+0x67>

801073a2 <seginit>:
{
801073a2:	f3 0f 1e fb          	endbr32 
801073a6:	55                   	push   %ebp
801073a7:	89 e5                	mov    %esp,%ebp
801073a9:	53                   	push   %ebx
801073aa:	83 ec 14             	sub    $0x14,%esp
  c = &cpus[cpuid()];
801073ad:	e8 b7 c4 ff ff       	call   80103869 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801073b2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801073b8:	66 c7 80 d8 5f 11 80 	movw   $0xffff,-0x7feea028(%eax)
801073bf:	ff ff 
801073c1:	66 c7 80 da 5f 11 80 	movw   $0x0,-0x7feea026(%eax)
801073c8:	00 00 
801073ca:	c6 80 dc 5f 11 80 00 	movb   $0x0,-0x7feea024(%eax)
801073d1:	0f b6 88 dd 5f 11 80 	movzbl -0x7feea023(%eax),%ecx
801073d8:	83 e1 f0             	and    $0xfffffff0,%ecx
801073db:	83 c9 1a             	or     $0x1a,%ecx
801073de:	83 e1 9f             	and    $0xffffff9f,%ecx
801073e1:	83 c9 80             	or     $0xffffff80,%ecx
801073e4:	88 88 dd 5f 11 80    	mov    %cl,-0x7feea023(%eax)
801073ea:	0f b6 88 de 5f 11 80 	movzbl -0x7feea022(%eax),%ecx
801073f1:	83 c9 0f             	or     $0xf,%ecx
801073f4:	83 e1 cf             	and    $0xffffffcf,%ecx
801073f7:	83 c9 c0             	or     $0xffffffc0,%ecx
801073fa:	88 88 de 5f 11 80    	mov    %cl,-0x7feea022(%eax)
80107400:	c6 80 df 5f 11 80 00 	movb   $0x0,-0x7feea021(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107407:	66 c7 80 e0 5f 11 80 	movw   $0xffff,-0x7feea020(%eax)
8010740e:	ff ff 
80107410:	66 c7 80 e2 5f 11 80 	movw   $0x0,-0x7feea01e(%eax)
80107417:	00 00 
80107419:	c6 80 e4 5f 11 80 00 	movb   $0x0,-0x7feea01c(%eax)
80107420:	0f b6 88 e5 5f 11 80 	movzbl -0x7feea01b(%eax),%ecx
80107427:	83 e1 f0             	and    $0xfffffff0,%ecx
8010742a:	83 c9 12             	or     $0x12,%ecx
8010742d:	83 e1 9f             	and    $0xffffff9f,%ecx
80107430:	83 c9 80             	or     $0xffffff80,%ecx
80107433:	88 88 e5 5f 11 80    	mov    %cl,-0x7feea01b(%eax)
80107439:	0f b6 88 e6 5f 11 80 	movzbl -0x7feea01a(%eax),%ecx
80107440:	83 c9 0f             	or     $0xf,%ecx
80107443:	83 e1 cf             	and    $0xffffffcf,%ecx
80107446:	83 c9 c0             	or     $0xffffffc0,%ecx
80107449:	88 88 e6 5f 11 80    	mov    %cl,-0x7feea01a(%eax)
8010744f:	c6 80 e7 5f 11 80 00 	movb   $0x0,-0x7feea019(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107456:	66 c7 80 e8 5f 11 80 	movw   $0xffff,-0x7feea018(%eax)
8010745d:	ff ff 
8010745f:	66 c7 80 ea 5f 11 80 	movw   $0x0,-0x7feea016(%eax)
80107466:	00 00 
80107468:	c6 80 ec 5f 11 80 00 	movb   $0x0,-0x7feea014(%eax)
8010746f:	c6 80 ed 5f 11 80 fa 	movb   $0xfa,-0x7feea013(%eax)
80107476:	0f b6 88 ee 5f 11 80 	movzbl -0x7feea012(%eax),%ecx
8010747d:	83 c9 0f             	or     $0xf,%ecx
80107480:	83 e1 cf             	and    $0xffffffcf,%ecx
80107483:	83 c9 c0             	or     $0xffffffc0,%ecx
80107486:	88 88 ee 5f 11 80    	mov    %cl,-0x7feea012(%eax)
8010748c:	c6 80 ef 5f 11 80 00 	movb   $0x0,-0x7feea011(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107493:	66 c7 80 f0 5f 11 80 	movw   $0xffff,-0x7feea010(%eax)
8010749a:	ff ff 
8010749c:	66 c7 80 f2 5f 11 80 	movw   $0x0,-0x7feea00e(%eax)
801074a3:	00 00 
801074a5:	c6 80 f4 5f 11 80 00 	movb   $0x0,-0x7feea00c(%eax)
801074ac:	c6 80 f5 5f 11 80 f2 	movb   $0xf2,-0x7feea00b(%eax)
801074b3:	0f b6 88 f6 5f 11 80 	movzbl -0x7feea00a(%eax),%ecx
801074ba:	83 c9 0f             	or     $0xf,%ecx
801074bd:	83 e1 cf             	and    $0xffffffcf,%ecx
801074c0:	83 c9 c0             	or     $0xffffffc0,%ecx
801074c3:	88 88 f6 5f 11 80    	mov    %cl,-0x7feea00a(%eax)
801074c9:	c6 80 f7 5f 11 80 00 	movb   $0x0,-0x7feea009(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801074d0:	05 d0 5f 11 80       	add    $0x80115fd0,%eax
  pd[0] = size-1;
801074d5:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
801074db:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801074df:	c1 e8 10             	shr    $0x10,%eax
801074e2:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801074e6:	8d 45 f2             	lea    -0xe(%ebp),%eax
801074e9:	0f 01 10             	lgdtl  (%eax)
}
801074ec:	83 c4 14             	add    $0x14,%esp
801074ef:	5b                   	pop    %ebx
801074f0:	5d                   	pop    %ebp
801074f1:	c3                   	ret    

801074f2 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801074f2:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074f6:	a1 04 6d 11 80       	mov    0x80116d04,%eax
801074fb:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107500:	0f 22 d8             	mov    %eax,%cr3
}
80107503:	c3                   	ret    

80107504 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107504:	f3 0f 1e fb          	endbr32 
80107508:	55                   	push   %ebp
80107509:	89 e5                	mov    %esp,%ebp
8010750b:	57                   	push   %edi
8010750c:	56                   	push   %esi
8010750d:	53                   	push   %ebx
8010750e:	83 ec 1c             	sub    $0x1c,%esp
80107511:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107514:	85 f6                	test   %esi,%esi
80107516:	0f 84 dd 00 00 00    	je     801075f9 <switchuvm+0xf5>
    panic("switchuvm: no process");
  if(p->kstack == 0)
8010751c:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80107520:	0f 84 e0 00 00 00    	je     80107606 <switchuvm+0x102>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80107526:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
8010752a:	0f 84 e3 00 00 00    	je     80107613 <switchuvm+0x10f>
    panic("switchuvm: no pgdir");

  pushcli();
80107530:	e8 7d da ff ff       	call   80104fb2 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107535:	e8 cf c2 ff ff       	call   80103809 <mycpu>
8010753a:	89 c3                	mov    %eax,%ebx
8010753c:	e8 c8 c2 ff ff       	call   80103809 <mycpu>
80107541:	8d 78 08             	lea    0x8(%eax),%edi
80107544:	e8 c0 c2 ff ff       	call   80103809 <mycpu>
80107549:	83 c0 08             	add    $0x8,%eax
8010754c:	c1 e8 10             	shr    $0x10,%eax
8010754f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107552:	e8 b2 c2 ff ff       	call   80103809 <mycpu>
80107557:	83 c0 08             	add    $0x8,%eax
8010755a:	c1 e8 18             	shr    $0x18,%eax
8010755d:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107564:	67 00 
80107566:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010756d:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
80107571:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107577:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
8010757e:	83 e2 f0             	and    $0xfffffff0,%edx
80107581:	83 ca 19             	or     $0x19,%edx
80107584:	83 e2 9f             	and    $0xffffff9f,%edx
80107587:	83 ca 80             	or     $0xffffff80,%edx
8010758a:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107590:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107597:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010759d:	e8 67 c2 ff ff       	call   80103809 <mycpu>
801075a2:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801075a9:	83 e2 ef             	and    $0xffffffef,%edx
801075ac:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801075b2:	e8 52 c2 ff ff       	call   80103809 <mycpu>
801075b7:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801075bd:	8b 5e 08             	mov    0x8(%esi),%ebx
801075c0:	e8 44 c2 ff ff       	call   80103809 <mycpu>
801075c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075cb:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801075ce:	e8 36 c2 ff ff       	call   80103809 <mycpu>
801075d3:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801075d9:	b8 28 00 00 00       	mov    $0x28,%eax
801075de:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801075e1:	8b 46 04             	mov    0x4(%esi),%eax
801075e4:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801075e9:	0f 22 d8             	mov    %eax,%cr3
  popcli();
801075ec:	e8 02 da ff ff       	call   80104ff3 <popcli>
}
801075f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075f4:	5b                   	pop    %ebx
801075f5:	5e                   	pop    %esi
801075f6:	5f                   	pop    %edi
801075f7:	5d                   	pop    %ebp
801075f8:	c3                   	ret    
    panic("switchuvm: no process");
801075f9:	83 ec 0c             	sub    $0xc,%esp
801075fc:	68 d2 8b 10 80       	push   $0x80108bd2
80107601:	e8 56 8d ff ff       	call   8010035c <panic>
    panic("switchuvm: no kstack");
80107606:	83 ec 0c             	sub    $0xc,%esp
80107609:	68 e8 8b 10 80       	push   $0x80108be8
8010760e:	e8 49 8d ff ff       	call   8010035c <panic>
    panic("switchuvm: no pgdir");
80107613:	83 ec 0c             	sub    $0xc,%esp
80107616:	68 fd 8b 10 80       	push   $0x80108bfd
8010761b:	e8 3c 8d ff ff       	call   8010035c <panic>

80107620 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107620:	f3 0f 1e fb          	endbr32 
80107624:	55                   	push   %ebp
80107625:	89 e5                	mov    %esp,%ebp
80107627:	56                   	push   %esi
80107628:	53                   	push   %ebx
80107629:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
8010762c:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107632:	77 4c                	ja     80107680 <inituvm+0x60>
    panic("inituvm: more than a page");
  mem = kalloc();
80107634:	e8 ca ab ff ff       	call   80102203 <kalloc>
80107639:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010763b:	83 ec 04             	sub    $0x4,%esp
8010763e:	68 00 10 00 00       	push   $0x1000
80107643:	6a 00                	push   $0x0
80107645:	50                   	push   %eax
80107646:	e8 04 db ff ff       	call   8010514f <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010764b:	83 c4 08             	add    $0x8,%esp
8010764e:	6a 06                	push   $0x6
80107650:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107656:	50                   	push   %eax
80107657:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010765c:	ba 00 00 00 00       	mov    $0x0,%edx
80107661:	8b 45 08             	mov    0x8(%ebp),%eax
80107664:	e8 c3 fc ff ff       	call   8010732c <mappages>
  memmove(mem, init, sz);
80107669:	83 c4 0c             	add    $0xc,%esp
8010766c:	56                   	push   %esi
8010766d:	ff 75 0c             	pushl  0xc(%ebp)
80107670:	53                   	push   %ebx
80107671:	e8 59 db ff ff       	call   801051cf <memmove>
}
80107676:	83 c4 10             	add    $0x10,%esp
80107679:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010767c:	5b                   	pop    %ebx
8010767d:	5e                   	pop    %esi
8010767e:	5d                   	pop    %ebp
8010767f:	c3                   	ret    
    panic("inituvm: more than a page");
80107680:	83 ec 0c             	sub    $0xc,%esp
80107683:	68 11 8c 10 80       	push   $0x80108c11
80107688:	e8 cf 8c ff ff       	call   8010035c <panic>

8010768d <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010768d:	f3 0f 1e fb          	endbr32 
80107691:	55                   	push   %ebp
80107692:	89 e5                	mov    %esp,%ebp
80107694:	57                   	push   %edi
80107695:	56                   	push   %esi
80107696:	53                   	push   %ebx
80107697:	83 ec 0c             	sub    $0xc,%esp
8010769a:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
8010769d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801076a0:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801076a6:	74 3c                	je     801076e4 <loaduvm+0x57>
    panic("loaduvm: addr must be page aligned");
801076a8:	83 ec 0c             	sub    $0xc,%esp
801076ab:	68 cc 8c 10 80       	push   $0x80108ccc
801076b0:	e8 a7 8c ff ff       	call   8010035c <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801076b5:	83 ec 0c             	sub    $0xc,%esp
801076b8:	68 2b 8c 10 80       	push   $0x80108c2b
801076bd:	e8 9a 8c ff ff       	call   8010035c <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076c2:	05 00 00 00 80       	add    $0x80000000,%eax
801076c7:	56                   	push   %esi
801076c8:	89 da                	mov    %ebx,%edx
801076ca:	03 55 14             	add    0x14(%ebp),%edx
801076cd:	52                   	push   %edx
801076ce:	50                   	push   %eax
801076cf:	ff 75 10             	pushl  0x10(%ebp)
801076d2:	e8 aa a1 ff ff       	call   80101881 <readi>
801076d7:	83 c4 10             	add    $0x10,%esp
801076da:	39 f0                	cmp    %esi,%eax
801076dc:	75 47                	jne    80107725 <loaduvm+0x98>
  for(i = 0; i < sz; i += PGSIZE){
801076de:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076e4:	39 fb                	cmp    %edi,%ebx
801076e6:	73 30                	jae    80107718 <loaduvm+0x8b>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801076e8:	89 da                	mov    %ebx,%edx
801076ea:	03 55 0c             	add    0xc(%ebp),%edx
801076ed:	b9 00 00 00 00       	mov    $0x0,%ecx
801076f2:	8b 45 08             	mov    0x8(%ebp),%eax
801076f5:	e8 c1 fb ff ff       	call   801072bb <walkpgdir>
801076fa:	85 c0                	test   %eax,%eax
801076fc:	74 b7                	je     801076b5 <loaduvm+0x28>
    pa = PTE_ADDR(*pte);
801076fe:	8b 00                	mov    (%eax),%eax
80107700:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107705:	89 fe                	mov    %edi,%esi
80107707:	29 de                	sub    %ebx,%esi
80107709:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010770f:	76 b1                	jbe    801076c2 <loaduvm+0x35>
      n = PGSIZE;
80107711:	be 00 10 00 00       	mov    $0x1000,%esi
80107716:	eb aa                	jmp    801076c2 <loaduvm+0x35>
      return -1;
  }
  return 0;
80107718:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010771d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107720:	5b                   	pop    %ebx
80107721:	5e                   	pop    %esi
80107722:	5f                   	pop    %edi
80107723:	5d                   	pop    %ebp
80107724:	c3                   	ret    
      return -1;
80107725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010772a:	eb f1                	jmp    8010771d <loaduvm+0x90>

8010772c <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010772c:	f3 0f 1e fb          	endbr32 
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
80107733:	57                   	push   %edi
80107734:	56                   	push   %esi
80107735:	53                   	push   %ebx
80107736:	83 ec 0c             	sub    $0xc,%esp
80107739:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010773c:	39 7d 10             	cmp    %edi,0x10(%ebp)
8010773f:	73 11                	jae    80107752 <deallocuvm+0x26>
    return oldsz;

  a = PGROUNDUP(newsz);
80107741:	8b 45 10             	mov    0x10(%ebp),%eax
80107744:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010774a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107750:	eb 19                	jmp    8010776b <deallocuvm+0x3f>
    return oldsz;
80107752:	89 f8                	mov    %edi,%eax
80107754:	eb 64                	jmp    801077ba <deallocuvm+0x8e>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107756:	c1 eb 16             	shr    $0x16,%ebx
80107759:	83 c3 01             	add    $0x1,%ebx
8010775c:	c1 e3 16             	shl    $0x16,%ebx
8010775f:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107765:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010776b:	39 fb                	cmp    %edi,%ebx
8010776d:	73 48                	jae    801077b7 <deallocuvm+0x8b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010776f:	b9 00 00 00 00       	mov    $0x0,%ecx
80107774:	89 da                	mov    %ebx,%edx
80107776:	8b 45 08             	mov    0x8(%ebp),%eax
80107779:	e8 3d fb ff ff       	call   801072bb <walkpgdir>
8010777e:	89 c6                	mov    %eax,%esi
    if(!pte)
80107780:	85 c0                	test   %eax,%eax
80107782:	74 d2                	je     80107756 <deallocuvm+0x2a>
    else if((*pte & PTE_P) != 0){
80107784:	8b 00                	mov    (%eax),%eax
80107786:	a8 01                	test   $0x1,%al
80107788:	74 db                	je     80107765 <deallocuvm+0x39>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010778a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010778f:	74 19                	je     801077aa <deallocuvm+0x7e>
        panic("kfree");
      char *v = P2V(pa);
80107791:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107796:	83 ec 0c             	sub    $0xc,%esp
80107799:	50                   	push   %eax
8010779a:	e8 3d a9 ff ff       	call   801020dc <kfree>
      *pte = 0;
8010779f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801077a5:	83 c4 10             	add    $0x10,%esp
801077a8:	eb bb                	jmp    80107765 <deallocuvm+0x39>
        panic("kfree");
801077aa:	83 ec 0c             	sub    $0xc,%esp
801077ad:	68 5a 7e 10 80       	push   $0x80107e5a
801077b2:	e8 a5 8b ff ff       	call   8010035c <panic>
    }
  }
  return newsz;
801077b7:	8b 45 10             	mov    0x10(%ebp),%eax
}
801077ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077bd:	5b                   	pop    %ebx
801077be:	5e                   	pop    %esi
801077bf:	5f                   	pop    %edi
801077c0:	5d                   	pop    %ebp
801077c1:	c3                   	ret    

801077c2 <allocuvm>:
{
801077c2:	f3 0f 1e fb          	endbr32 
801077c6:	55                   	push   %ebp
801077c7:	89 e5                	mov    %esp,%ebp
801077c9:	57                   	push   %edi
801077ca:	56                   	push   %esi
801077cb:	53                   	push   %ebx
801077cc:	83 ec 1c             	sub    $0x1c,%esp
801077cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
801077d2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801077d5:	85 ff                	test   %edi,%edi
801077d7:	0f 88 c0 00 00 00    	js     8010789d <allocuvm+0xdb>
  if(newsz < oldsz)
801077dd:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801077e0:	72 11                	jb     801077f3 <allocuvm+0x31>
  a = PGROUNDUP(oldsz);
801077e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801077e5:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801077eb:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801077f1:	eb 39                	jmp    8010782c <allocuvm+0x6a>
    return oldsz;
801077f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801077f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801077f9:	e9 a6 00 00 00       	jmp    801078a4 <allocuvm+0xe2>
      cprintf("allocuvm out of memory\n");
801077fe:	83 ec 0c             	sub    $0xc,%esp
80107801:	68 49 8c 10 80       	push   $0x80108c49
80107806:	e8 1e 8e ff ff       	call   80100629 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010780b:	83 c4 0c             	add    $0xc,%esp
8010780e:	ff 75 0c             	pushl  0xc(%ebp)
80107811:	57                   	push   %edi
80107812:	ff 75 08             	pushl  0x8(%ebp)
80107815:	e8 12 ff ff ff       	call   8010772c <deallocuvm>
      return 0;
8010781a:	83 c4 10             	add    $0x10,%esp
8010781d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107824:	eb 7e                	jmp    801078a4 <allocuvm+0xe2>
  for(; a < newsz; a += PGSIZE){
80107826:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010782c:	39 fe                	cmp    %edi,%esi
8010782e:	73 74                	jae    801078a4 <allocuvm+0xe2>
    mem = kalloc();
80107830:	e8 ce a9 ff ff       	call   80102203 <kalloc>
80107835:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107837:	85 c0                	test   %eax,%eax
80107839:	74 c3                	je     801077fe <allocuvm+0x3c>
    memset(mem, 0, PGSIZE);
8010783b:	83 ec 04             	sub    $0x4,%esp
8010783e:	68 00 10 00 00       	push   $0x1000
80107843:	6a 00                	push   $0x0
80107845:	50                   	push   %eax
80107846:	e8 04 d9 ff ff       	call   8010514f <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010784b:	83 c4 08             	add    $0x8,%esp
8010784e:	6a 06                	push   $0x6
80107850:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107856:	50                   	push   %eax
80107857:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010785c:	89 f2                	mov    %esi,%edx
8010785e:	8b 45 08             	mov    0x8(%ebp),%eax
80107861:	e8 c6 fa ff ff       	call   8010732c <mappages>
80107866:	83 c4 10             	add    $0x10,%esp
80107869:	85 c0                	test   %eax,%eax
8010786b:	79 b9                	jns    80107826 <allocuvm+0x64>
      cprintf("allocuvm out of memory (2)\n");
8010786d:	83 ec 0c             	sub    $0xc,%esp
80107870:	68 61 8c 10 80       	push   $0x80108c61
80107875:	e8 af 8d ff ff       	call   80100629 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010787a:	83 c4 0c             	add    $0xc,%esp
8010787d:	ff 75 0c             	pushl  0xc(%ebp)
80107880:	57                   	push   %edi
80107881:	ff 75 08             	pushl  0x8(%ebp)
80107884:	e8 a3 fe ff ff       	call   8010772c <deallocuvm>
      kfree(mem);
80107889:	89 1c 24             	mov    %ebx,(%esp)
8010788c:	e8 4b a8 ff ff       	call   801020dc <kfree>
      return 0;
80107891:	83 c4 10             	add    $0x10,%esp
80107894:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010789b:	eb 07                	jmp    801078a4 <allocuvm+0xe2>
    return 0;
8010789d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801078a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078aa:	5b                   	pop    %ebx
801078ab:	5e                   	pop    %esi
801078ac:	5f                   	pop    %edi
801078ad:	5d                   	pop    %ebp
801078ae:	c3                   	ret    

801078af <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801078af:	f3 0f 1e fb          	endbr32 
801078b3:	55                   	push   %ebp
801078b4:	89 e5                	mov    %esp,%ebp
801078b6:	56                   	push   %esi
801078b7:	53                   	push   %ebx
801078b8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801078bb:	85 f6                	test   %esi,%esi
801078bd:	74 1a                	je     801078d9 <freevm+0x2a>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
801078bf:	83 ec 04             	sub    $0x4,%esp
801078c2:	6a 00                	push   $0x0
801078c4:	68 00 00 00 80       	push   $0x80000000
801078c9:	56                   	push   %esi
801078ca:	e8 5d fe ff ff       	call   8010772c <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801078cf:	83 c4 10             	add    $0x10,%esp
801078d2:	bb 00 00 00 00       	mov    $0x0,%ebx
801078d7:	eb 26                	jmp    801078ff <freevm+0x50>
    panic("freevm: no pgdir");
801078d9:	83 ec 0c             	sub    $0xc,%esp
801078dc:	68 7d 8c 10 80       	push   $0x80108c7d
801078e1:	e8 76 8a ff ff       	call   8010035c <panic>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078eb:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801078f0:	83 ec 0c             	sub    $0xc,%esp
801078f3:	50                   	push   %eax
801078f4:	e8 e3 a7 ff ff       	call   801020dc <kfree>
801078f9:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801078fc:	83 c3 01             	add    $0x1,%ebx
801078ff:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
80107905:	77 09                	ja     80107910 <freevm+0x61>
    if(pgdir[i] & PTE_P){
80107907:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
8010790a:	a8 01                	test   $0x1,%al
8010790c:	74 ee                	je     801078fc <freevm+0x4d>
8010790e:	eb d6                	jmp    801078e6 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107910:	83 ec 0c             	sub    $0xc,%esp
80107913:	56                   	push   %esi
80107914:	e8 c3 a7 ff ff       	call   801020dc <kfree>
}
80107919:	83 c4 10             	add    $0x10,%esp
8010791c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010791f:	5b                   	pop    %ebx
80107920:	5e                   	pop    %esi
80107921:	5d                   	pop    %ebp
80107922:	c3                   	ret    

80107923 <setupkvm>:
{
80107923:	f3 0f 1e fb          	endbr32 
80107927:	55                   	push   %ebp
80107928:	89 e5                	mov    %esp,%ebp
8010792a:	56                   	push   %esi
8010792b:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
8010792c:	e8 d2 a8 ff ff       	call   80102203 <kalloc>
80107931:	89 c6                	mov    %eax,%esi
80107933:	85 c0                	test   %eax,%eax
80107935:	74 55                	je     8010798c <setupkvm+0x69>
  memset(pgdir, 0, PGSIZE);
80107937:	83 ec 04             	sub    $0x4,%esp
8010793a:	68 00 10 00 00       	push   $0x1000
8010793f:	6a 00                	push   $0x0
80107941:	50                   	push   %eax
80107942:	e8 08 d8 ff ff       	call   8010514f <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107947:	83 c4 10             	add    $0x10,%esp
8010794a:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
8010794f:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107955:	73 35                	jae    8010798c <setupkvm+0x69>
                (uint)k->phys_start, k->perm) < 0) {
80107957:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010795a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010795d:	29 c1                	sub    %eax,%ecx
8010795f:	83 ec 08             	sub    $0x8,%esp
80107962:	ff 73 0c             	pushl  0xc(%ebx)
80107965:	50                   	push   %eax
80107966:	8b 13                	mov    (%ebx),%edx
80107968:	89 f0                	mov    %esi,%eax
8010796a:	e8 bd f9 ff ff       	call   8010732c <mappages>
8010796f:	83 c4 10             	add    $0x10,%esp
80107972:	85 c0                	test   %eax,%eax
80107974:	78 05                	js     8010797b <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107976:	83 c3 10             	add    $0x10,%ebx
80107979:	eb d4                	jmp    8010794f <setupkvm+0x2c>
      freevm(pgdir);
8010797b:	83 ec 0c             	sub    $0xc,%esp
8010797e:	56                   	push   %esi
8010797f:	e8 2b ff ff ff       	call   801078af <freevm>
      return 0;
80107984:	83 c4 10             	add    $0x10,%esp
80107987:	be 00 00 00 00       	mov    $0x0,%esi
}
8010798c:	89 f0                	mov    %esi,%eax
8010798e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107991:	5b                   	pop    %ebx
80107992:	5e                   	pop    %esi
80107993:	5d                   	pop    %ebp
80107994:	c3                   	ret    

80107995 <kvmalloc>:
{
80107995:	f3 0f 1e fb          	endbr32 
80107999:	55                   	push   %ebp
8010799a:	89 e5                	mov    %esp,%ebp
8010799c:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010799f:	e8 7f ff ff ff       	call   80107923 <setupkvm>
801079a4:	a3 04 6d 11 80       	mov    %eax,0x80116d04
  switchkvm();
801079a9:	e8 44 fb ff ff       	call   801074f2 <switchkvm>
}
801079ae:	c9                   	leave  
801079af:	c3                   	ret    

801079b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801079b0:	f3 0f 1e fb          	endbr32 
801079b4:	55                   	push   %ebp
801079b5:	89 e5                	mov    %esp,%ebp
801079b7:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801079ba:	b9 00 00 00 00       	mov    $0x0,%ecx
801079bf:	8b 55 0c             	mov    0xc(%ebp),%edx
801079c2:	8b 45 08             	mov    0x8(%ebp),%eax
801079c5:	e8 f1 f8 ff ff       	call   801072bb <walkpgdir>
  if(pte == 0)
801079ca:	85 c0                	test   %eax,%eax
801079cc:	74 05                	je     801079d3 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
801079ce:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801079d1:	c9                   	leave  
801079d2:	c3                   	ret    
    panic("clearpteu");
801079d3:	83 ec 0c             	sub    $0xc,%esp
801079d6:	68 8e 8c 10 80       	push   $0x80108c8e
801079db:	e8 7c 89 ff ff       	call   8010035c <panic>

801079e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801079e0:	f3 0f 1e fb          	endbr32 
801079e4:	55                   	push   %ebp
801079e5:	89 e5                	mov    %esp,%ebp
801079e7:	57                   	push   %edi
801079e8:	56                   	push   %esi
801079e9:	53                   	push   %ebx
801079ea:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801079ed:	e8 31 ff ff ff       	call   80107923 <setupkvm>
801079f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
801079f5:	85 c0                	test   %eax,%eax
801079f7:	0f 84 b8 00 00 00    	je     80107ab5 <copyuvm+0xd5>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801079fd:	bf 00 00 00 00       	mov    $0x0,%edi
80107a02:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107a05:	0f 83 aa 00 00 00    	jae    80107ab5 <copyuvm+0xd5>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a0b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107a0e:	b9 00 00 00 00       	mov    $0x0,%ecx
80107a13:	89 fa                	mov    %edi,%edx
80107a15:	8b 45 08             	mov    0x8(%ebp),%eax
80107a18:	e8 9e f8 ff ff       	call   801072bb <walkpgdir>
80107a1d:	85 c0                	test   %eax,%eax
80107a1f:	74 65                	je     80107a86 <copyuvm+0xa6>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107a21:	8b 00                	mov    (%eax),%eax
80107a23:	a8 01                	test   $0x1,%al
80107a25:	74 6c                	je     80107a93 <copyuvm+0xb3>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107a27:	89 c6                	mov    %eax,%esi
80107a29:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
80107a2f:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a34:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80107a37:	e8 c7 a7 ff ff       	call   80102203 <kalloc>
80107a3c:	89 c3                	mov    %eax,%ebx
80107a3e:	85 c0                	test   %eax,%eax
80107a40:	74 5e                	je     80107aa0 <copyuvm+0xc0>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a42:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80107a48:	83 ec 04             	sub    $0x4,%esp
80107a4b:	68 00 10 00 00       	push   $0x1000
80107a50:	56                   	push   %esi
80107a51:	50                   	push   %eax
80107a52:	e8 78 d7 ff ff       	call   801051cf <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107a57:	83 c4 08             	add    $0x8,%esp
80107a5a:	ff 75 e0             	pushl  -0x20(%ebp)
80107a5d:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107a63:	53                   	push   %ebx
80107a64:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107a6f:	e8 b8 f8 ff ff       	call   8010732c <mappages>
80107a74:	83 c4 10             	add    $0x10,%esp
80107a77:	85 c0                	test   %eax,%eax
80107a79:	78 25                	js     80107aa0 <copyuvm+0xc0>
  for(i = 0; i < sz; i += PGSIZE){
80107a7b:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107a81:	e9 7c ff ff ff       	jmp    80107a02 <copyuvm+0x22>
      panic("copyuvm: pte should exist");
80107a86:	83 ec 0c             	sub    $0xc,%esp
80107a89:	68 98 8c 10 80       	push   $0x80108c98
80107a8e:	e8 c9 88 ff ff       	call   8010035c <panic>
      panic("copyuvm: page not present");
80107a93:	83 ec 0c             	sub    $0xc,%esp
80107a96:	68 b2 8c 10 80       	push   $0x80108cb2
80107a9b:	e8 bc 88 ff ff       	call   8010035c <panic>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107aa0:	83 ec 0c             	sub    $0xc,%esp
80107aa3:	ff 75 dc             	pushl  -0x24(%ebp)
80107aa6:	e8 04 fe ff ff       	call   801078af <freevm>
  return 0;
80107aab:	83 c4 10             	add    $0x10,%esp
80107aae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80107ab5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107abb:	5b                   	pop    %ebx
80107abc:	5e                   	pop    %esi
80107abd:	5f                   	pop    %edi
80107abe:	5d                   	pop    %ebp
80107abf:	c3                   	ret    

80107ac0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107ac0:	f3 0f 1e fb          	endbr32 
80107ac4:	55                   	push   %ebp
80107ac5:	89 e5                	mov    %esp,%ebp
80107ac7:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107aca:	b9 00 00 00 00       	mov    $0x0,%ecx
80107acf:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ad5:	e8 e1 f7 ff ff       	call   801072bb <walkpgdir>
  if((*pte & PTE_P) == 0)
80107ada:	8b 00                	mov    (%eax),%eax
80107adc:	a8 01                	test   $0x1,%al
80107ade:	74 10                	je     80107af0 <uva2ka+0x30>
    return 0;
  if((*pte & PTE_U) == 0)
80107ae0:	a8 04                	test   $0x4,%al
80107ae2:	74 13                	je     80107af7 <uva2ka+0x37>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107ae4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ae9:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107aee:	c9                   	leave  
80107aef:	c3                   	ret    
    return 0;
80107af0:	b8 00 00 00 00       	mov    $0x0,%eax
80107af5:	eb f7                	jmp    80107aee <uva2ka+0x2e>
    return 0;
80107af7:	b8 00 00 00 00       	mov    $0x0,%eax
80107afc:	eb f0                	jmp    80107aee <uva2ka+0x2e>

80107afe <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107afe:	f3 0f 1e fb          	endbr32 
80107b02:	55                   	push   %ebp
80107b03:	89 e5                	mov    %esp,%ebp
80107b05:	57                   	push   %edi
80107b06:	56                   	push   %esi
80107b07:	53                   	push   %ebx
80107b08:	83 ec 0c             	sub    $0xc,%esp
80107b0b:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b0e:	eb 25                	jmp    80107b35 <copyout+0x37>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b10:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b13:	29 f2                	sub    %esi,%edx
80107b15:	01 d0                	add    %edx,%eax
80107b17:	83 ec 04             	sub    $0x4,%esp
80107b1a:	53                   	push   %ebx
80107b1b:	ff 75 10             	pushl  0x10(%ebp)
80107b1e:	50                   	push   %eax
80107b1f:	e8 ab d6 ff ff       	call   801051cf <memmove>
    len -= n;
80107b24:	29 df                	sub    %ebx,%edi
    buf += n;
80107b26:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b29:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80107b2f:	89 45 0c             	mov    %eax,0xc(%ebp)
80107b32:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80107b35:	85 ff                	test   %edi,%edi
80107b37:	74 2f                	je     80107b68 <copyout+0x6a>
    va0 = (uint)PGROUNDDOWN(va);
80107b39:	8b 75 0c             	mov    0xc(%ebp),%esi
80107b3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b42:	83 ec 08             	sub    $0x8,%esp
80107b45:	56                   	push   %esi
80107b46:	ff 75 08             	pushl  0x8(%ebp)
80107b49:	e8 72 ff ff ff       	call   80107ac0 <uva2ka>
    if(pa0 == 0)
80107b4e:	83 c4 10             	add    $0x10,%esp
80107b51:	85 c0                	test   %eax,%eax
80107b53:	74 20                	je     80107b75 <copyout+0x77>
    n = PGSIZE - (va - va0);
80107b55:	89 f3                	mov    %esi,%ebx
80107b57:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80107b5a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107b60:	39 df                	cmp    %ebx,%edi
80107b62:	73 ac                	jae    80107b10 <copyout+0x12>
      n = len;
80107b64:	89 fb                	mov    %edi,%ebx
80107b66:	eb a8                	jmp    80107b10 <copyout+0x12>
  }
  return 0;
80107b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b70:	5b                   	pop    %ebx
80107b71:	5e                   	pop    %esi
80107b72:	5f                   	pop    %edi
80107b73:	5d                   	pop    %ebp
80107b74:	c3                   	ret    
      return -1;
80107b75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b7a:	eb f1                	jmp    80107b6d <copyout+0x6f>
