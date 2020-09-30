Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4349727DF1A
	for <lists+linux-bcache@lfdr.de>; Wed, 30 Sep 2020 05:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725320AbgI3DwM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Sep 2020 23:52:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:40004 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgI3DwL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Sep 2020 23:52:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A70ABABA2;
        Wed, 30 Sep 2020 03:52:09 +0000 (UTC)
To:     Marc Smith <msmith626@gmail.com>
Cc:     linux-bcache@vger.kernel.org
References: <CAH6h+hdWRN-wG9_JJoCSfxs55jeTLzE5ia+DK19GPtJA59EXxQ@mail.gmail.com>
 <497aac95-c9c9-61e7-edc1-c38154f1e881@suse.de>
 <CAH6h+hfjXxBSAJSfSEXnzB8OvYMELFeM0fNmmhZYPv_AvbTVkA@mail.gmail.com>
 <CAH6h+hex3-AwfvGZoCpsttdUp69f52gE8mUM9Ua+1xyZ=54bMg@mail.gmail.com>
 <ba2bbdcc-d894-dea6-1537-76dc87fcc320@suse.de>
 <CAH6h+hfKpFad=pE2vsvRBUGpA09hmwkP3DDboxyDZ2EGSwT=bg@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 mQINBFYX6S8BEAC9VSamb2aiMTQREFXK4K/W7nGnAinca7MRuFUD4JqWMJ9FakNRd/E0v30F
 qvZ2YWpidPjaIxHwu3u9tmLKqS+2vnP0k7PRHXBYbtZEMpy3kCzseNfdrNqwJ54A430BHf2S
 GMVRVENiScsnh4SnaYjFVvB8SrlhTsgVEXEBBma5Ktgq9YSoy5miatWmZvHLFTQgFMabCz/P
 j5/xzykrF6yHo0rHZtwzQzF8rriOplAFCECp/t05+OeHHxjSqSI0P/G79Ll+AJYLRRm9til/
 K6yz/1hX5xMToIkYrshDJDrUc8DjEpISQQPhG19PzaUf3vFpmnSVYprcWfJWsa2wZyyjRFkf
 J51S82WfclafNC6N7eRXedpRpG6udUAYOA1YdtlyQRZa84EJvMzW96iSL1Gf+ZGtRuM3k49H
 1wiWOjlANiJYSIWyzJjxAd/7Xtiy/s3PRKL9u9y25ftMLFa1IljiDG+mdY7LyAGfvdtIkanr
 iBpX4gWXd7lNQFLDJMfShfu+CTMCdRzCAQ9hIHPmBeZDJxKq721CyBiGAhRxDN+TYiaG/UWT
 7IB7LL4zJrIe/xQ8HhRO+2NvT89o0LxEFKBGg39yjTMIrjbl2ZxY488+56UV4FclubrG+t16
 r2KrandM7P5RjR+cuHhkKseim50Qsw0B+Eu33Hjry7YCihmGswARAQABtBhDb2x5IExpIDxj
 b2x5bGlAc3VzZS5kZT6JAlYEEwEIAEACGyMHCwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgBYh
 BOo+RS/0+Uhgjej60Mc5B5Nrffj8BQJcR84dBQkY++fuAAoJEMc5B5Nrffj8ixcP/3KAKg1X
 EcoW4u/0z+Ton5rCyb/NpAww8MuRjNW82UBUac7yCi1y3OW7NtLjuBLw5SaVG5AArb7IF3U0
 qTOobqfl5XHsT0o5wFHZaKUrnHb6y7V3SplsJWfkP3JmOooJsQB3z3K96ZTkFelsNb0ZaBRu
 gV+LA4MomhQ+D3BCDR1it1OX/tpvm2uaDF6s/8uFtcDEM9eQeqATN/QAJ49nvU/I8zDSY9rc
 0x9mP0x+gH4RccbnoPu/rUG6Fm1ZpLrbb6NpaYBBJ/V1BC4lIOjnd24bsoQrQmnJn9dSr60X
 1MY60XDszIyzRw7vbJcUn6ZzPNFDxFFT9diIb+wBp+DD8ZlD/hnVpl4f921ZbvfOSsXAJrKB
 1hGY17FPwelp1sPcK2mDT+pfHEMV+OQdZzD2OCKtza/5IYismJJm3oVUYMogb5vDNAw9X2aP
 XgwUuG+FDEFPamFMUwIfzYHcePfqf0mMsaeSgtA/xTxzx/0MLjUJHl46Bc0uKDhv7QUyGz0j
 Ywgr2mHTvG+NWQ/mDeHNGkcnsnp3IY7koDHnN2xMFXzY4bn9m8ctqKo2roqjCzoxD/njoAhf
 KBzdybLHATqJG/yiZSbCxDA1n/J4FzPyZ0rNHUAJ/QndmmVspE9syFpFCKigvvyrzm016+k+
 FJ59Q6RG4MSy/+J565Xj+DNY3/dCuQINBFYX6S8BEADZP+2cl4DRFaSaBms08W8/smc5T2CO
 YhAoygZn71rB7Djml2ZdvrLRjR8Qbn0Q/2L2gGUVc63pJnbrjlXSx2LfAFE0SlfYIJ11aFdF
 9w7RvqWByQjDJor3Z0fWvPExplNgMvxpD0U0QrVT5dIGTx9hadejCl/ug09Lr6MPQn+a4+qs
 aRWwgCSHaIuDkH3zI1MJXiqXXFKUzJ/Fyx6R72rqiMPHH2nfwmMu6wOXAXb7+sXjZz5Po9GJ
 g2OcEc+rpUtKUJGyeQsnCDxUcqJXZDBi/GnhPCcraQuqiQ7EGWuJfjk51vaI/rW4bZkA9yEP
 B9rBYngbz7cQymUsfxuTT8OSlhxjP3l4ZIZFKIhDaQeZMj8pumBfEVUyiF6KVSfgfNQ/5PpM
 R4/pmGbRqrAAElhrRPbKQnCkGWDr8zG+AjN1KF6rHaFgAIO7TtZ+F28jq4reLkur0N5tQFww
 wFwxzROdeLHuZjL7eEtcnNnzSkXHczLkV4kQ3+vr/7Gm65mQfnVpg6JpwpVrbDYQeOFlxZ8+
 GERY5Dag4KgKa/4cSZX2x/5+KkQx9wHwackw5gDCvAdZ+Q81nm6tRxEYBBiVDQZYqO73stgT
 ZyrkxykUbQIy8PI+g7XMDCMnPiDncQqgf96KR3cvw4wN8QrgA6xRo8xOc2C3X7jTMQUytCz9
 0MyV1QARAQABiQI8BBgBCAAmAhsMFiEE6j5FL/T5SGCN6PrQxzkHk2t9+PwFAlxHziAFCRj7
 5/EACgkQxzkHk2t9+PxgfA//cH5R1DvpJPwraTAl24SUcG9EWe+NXyqveApe05nk15zEuxxd
 e4zFEjo+xYZilSveLqYHrm/amvQhsQ6JLU+8N60DZHVcXbw1Eb8CEjM5oXdbcJpXh1/1BEwl
 4phsQMkxOTns51bGDhTQkv4lsZKvNByB9NiiMkT43EOx14rjkhHw3rnqoI7ogu8OO7XWfKcL
 CbchjJ8t3c2XK1MUe056yPpNAT2XPNF2EEBPG2Y2F4vLgEbPv1EtpGUS1+JvmK3APxjXUl5z
 6xrxCQDWM5AAtGfM/IswVjbZYSJYyH4BQKrShzMb0rWUjkpXvvjsjt8rEXpZEYJgX9jvCoxt
 oqjCKiVLpwje9WkEe9O9VxljmPvxAhVqJjX62S+TGp93iD+mvpCoHo3+CcvyRcilz+Ko8lfO
 hS9tYT0HDUiDLvpUyH1AR2xW9RGDevGfwGTpF0K6cLouqyZNdhlmNciX48tFUGjakRFsxRmX
 K0Jx4CEZubakJe+894sX6pvNFiI7qUUdB882i5GR3v9ijVPhaMr8oGuJ3kvwBIA8lvRBGVGn
 9xvzkQ8Prpbqh30I4NMp8MjFdkwCN6znBKPHdjNTwE5PRZH0S9J0o67IEIvHfH0eAWAsgpTz
 +jwc7VKH7vkvgscUhq/v1/PEWCAqh9UHy7R/jiUxwzw/288OpgO+i+2l11Y=
Subject: Re: [ 186.758123] kernel BUG at drivers/md/bcache/writeback.c:324!
Message-ID: <8f7d3876-1225-214c-1b5b-788390d699d0@suse.de>
Date:   Wed, 30 Sep 2020 11:52:05 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAH6h+hfKpFad=pE2vsvRBUGpA09hmwkP3DDboxyDZ2EGSwT=bg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/9/30 11:30, Marc Smith wrote:
> On Tue, Sep 29, 2020 at 9:37 PM Coly Li <colyli@suse.de> wrote:
>>
>> On 2020/9/30 03:18, Marc Smith wrote:
>>> Hi Coly,
>>>
>>> So nearly one year later, and I haven't hit this issue since running
>>> 5.4.x until now. It seems to happen on a system for just ONE of the
>>> backing devices (4 backing devices per cache device). Running Linux
>>> 5.4.45 (vanilla kernel.org):
>>>
>>> --snip--
>>> [ 1597.707235] bcache: bch_journal_replay() journal replay done, 0
>>> keys in 1 entries, seq 1412486
>>> [ 1597.712131] bcache: bch_cached_dev_attach() Caching md123 as
>>> bcache3 on set 521f7664-690d-4680-9b0d-1299fcee4321
>>> [ 1597.715109] bcache: bch_cached_dev_attach() Caching md124 as
>>> bcache2 on set 521f7664-690d-4680-9b0d-1299fcee4321
>>> [ 1597.718674] bcache: bch_cached_dev_attach() Caching md125 as
>>> bcache1 on set 521f7664-690d-4680-9b0d-1299fcee4321
>>> [ 1597.723378] ------------[ cut here ]------------
>>> [ 1597.723381] kernel BUG at drivers/md/bcache/writeback.c:562!
>>> [ 1597.723389] invalid opcode: 0000 [#1] SMP NOPTI
>>> [ 1597.723514] CPU: 0 PID: 2356 Comm: bcache_writebac Kdump: loaded
>>> Tainted: G           OE     5.4.45-esos.prod #1
>>> [ 1597.723746] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>>> [ 1597.723877] RIP: 0010:dirty_pred+0x17/0x21 [bcache]
>>> [ 1597.723991] Code: 09 89 43 68 5b 5d 41 5c e9 e4 fd ff ff f0 48 0f
>>> b3 3e c3 48 8b 06 8b 8f 38 f4 ff ff 48 89 c2 81 e2 ff ff 0f 00 48 39
>>> d1 74 02 <0f> 0b 48 c1 e8 24 83 e0 01 c3 41 56 41 55 41 54 55 48 89 fd
>>> 48 83
>>> [ 1597.724426] RSP: 0018:ffffc900007f7bf0 EFLAGS: 00010297
>>> [ 1597.724543] RAX: 9000000001000002 RBX: ffff88855f800c50 RCX: 0000000000000001
>>> [ 1597.724699] RDX: 0000000000000002 RSI: ffff8885125a4f08 RDI: ffff88855f800c50
>>> [ 1597.724857] RBP: ffff8885125a4f08 R08: 0000000000000001 R09: 0000000000000001
>>> [ 1597.725015] R10: 9000000001000002 R11: 0000000000000001 R12: ffffc900007f7dd0
>>> [ 1597.725175] R13: ffff8885a8797400 R14: ffff8885a87974c8 R15: 0000000000000000
>>> [ 1597.725309] FS:  0000000000000000(0000) GS:ffff888627a00000(0000)
>>> knlGS:0000000000000000
>>> [ 1597.725428] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 1597.725517] CR2: 0000000000ce9d00 CR3: 000000059f304000 CR4: 0000000000340ef0
>>> [ 1597.725623] Call Trace:
>>> [ 1597.725672]  refill_keybuf_fn+0x66/0x1a3 [bcache]
>>> [ 1597.725743]  ? mca_find+0x50/0x50 [bcache]
>>> [ 1597.726310]  bch_btree_map_keys_recurse+0x79/0x14c [bcache]
>>> [ 1597.726433] bcache: bch_cached_dev_attach() Caching md126 as
>>> bcache0 on set 521f7664-690d-4680-9b0d-1299fcee4321
>>> [ 1597.726880]  ? __switch_to_asm+0x34/0x70
>>> [ 1597.728612] bcache: register_cache() registered cache device dm-0
>>> [ 1597.729128]  ? bch_btree_node_get+0xce/0x1bd [bcache]
>>> [ 1597.730553]  ? mca_find+0x50/0x50 [bcache]
>>> [ 1597.731102]  bch_btree_map_keys_recurse+0xc1/0x14c [bcache]
>>> [ 1597.731672]  ? __switch_to_asm+0x40/0x70
>>> [ 1597.732219]  ? __switch_to_asm+0x34/0x70
>>> [ 1597.732770]  ? __schedule+0x492/0x4b5
>>> [ 1597.733319]  ? rwsem_optimistic_spin+0x186/0x1ae
>>> [ 1597.733873]  ? mca_find+0x50/0x50 [bcache]
>>> [ 1597.734431]  bch_btree_map_keys+0x87/0xd5 [bcache]
>>> [ 1597.734987]  ? clear_bit+0x6/0x6 [bcache]
>>> [ 1597.735537]  bch_refill_keybuf+0x81/0x1ae [bcache]
>>> [ 1597.736091]  ? remove_wait_queue+0x41/0x41
>>> [ 1597.736645]  ? clear_bit+0x6/0x6 [bcache]
>>> [ 1597.737189]  bch_writeback_thread+0x35e/0x507 [bcache]
>>> [ 1597.737755]  ? read_dirty+0x448/0x448 [bcache]
>>> [ 1597.738311]  kthread+0xe4/0xe9
>>> [ 1597.738843]  ? kthread_flush_worker+0x70/0x70
>>> [ 1597.739405]  ret_from_fork+0x22/0x40
>>> [ 1597.739951] Modules linked in: nvmet_fc(O) nvmet_rdma(O) nvmet(O)
>>> bcache qla2xxx_scst(OE) nvme_fc(O) nvme_fabrics(O) bonding
>>> cls_switchtec(O) qede qed mlx5_core(O) mlxfw(O) bna rdmavt(O)
>>> ib_umad(O) rdma_ucm(O) ib_uverbs(O) ib_srp(O) rdma_cm(O) ib_cm(O)
>>> iw_cm(O) iw_cxgb4(O) iw_cxgb3(O) ib_qib(O) mlx4_ib(O) mlx4_core(O)
>>> ib_core(O) ib_mthca(O) nvme(O) nvme_core(O) mlx_compat(O)
>>> [ 1597.743363] ---[ end trace 095defe1dc682fed ]---
>>> [ 1597.743983] RIP: 0010:dirty_pred+0x17/0x21 [bcache]
>>> [ 1597.746015] Code: 09 89 43 68 5b 5d 41 5c e9 e4 fd ff ff f0 48 0f
>>> b3 3e c3 48 8b 06 8b 8f 38 f4 ff ff 48 89 c2 81 e2 ff ff 0f 00 48 39
>>> d1 74 02 <0f> 0b 48 c1 e8 24 83 e0 01 c3 41 56 41 55 41 54 55 48 89 fd
>>> 48 83
>>> [ 1597.747806] RSP: 0018:ffffc900007f7bf0 EFLAGS: 00010297
>>> [ 1597.748449] RAX: 9000000001000002 RBX: ffff88855f800c50 RCX: 0000000000000001
>>> [ 1597.749097] RDX: 0000000000000002 RSI: ffff8885125a4f08 RDI: ffff88855f800c50
>>> [ 1597.749769] RBP: ffff8885125a4f08 R08: 0000000000000001 R09: 0000000000000001
>>> [ 1597.750427] R10: 9000000001000002 R11: 0000000000000001 R12: ffffc900007f7dd0
>>> [ 1597.751073] R13: ffff8885a8797400 R14: ffff8885a87974c8 R15: 0000000000000000
>>> [ 1597.751745] FS:  0000000000000000(0000) GS:ffff888627a00000(0000)
>>> knlGS:0000000000000000
>>> [ 1597.752900] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 1597.753544] CR2: 0000000000ce9d00 CR3: 000000059f304000 CR4: 0000000000340ef0
>>> --snip--
>>>
>>> This line at the beginning of that snippet above catches my eye (when
>>> registering the cache device):
>>> [ 1597.707235] bcache: bch_journal_replay() journal replay done, 0
>>> keys in 1 entries, seq 1412486
>>>
>>> This machine was in a crashed state, and then upon resetting it, I hit
>>> the issue above when registering the backing/cache devices. Is the
>>> cache/journal perhaps corrupted? Any way to manually
>>> intervene/resolve?
>>>
>>> Thanks for your time.
>>
>> Hi Marc,
>>
>> Thanks for the reporting. Maybe this is a hidden issue in btree code
>> (just a quick guess without any evidence).
>>
>> For the journal information you mentioned,
>> "[ 1597.707235] bcache: bch_journal_replay() journal replay done, 0
>> keys in 1 entries, seq 1412486"
>> Because a journal_meta() operation may only flush a journal set block
>> with cache set meta data without any extra btree key, the message itself
>> is legal. I am not able to get suspicious clue from it.
> 
> Okay, thank you for the explanation. I took a peek at
> bch_journal_replay() and understand now.
> 
> 
>>
>> Maybe the new kernel just improves to make less mistake for the hidden
>> bug, but the root cause is not identified yet.
>>
>> BTW, there are 2 things in my brain,
>> 1) Do you have this patch in your kernel,
>>    commit be23e837333a ("bcache: fix potential deadlock problem in
>> btree_gc_coalesce")
> 
> No, looks like this fix came with 5.4.49 (I'm using .45 currently).
> Will update ASAP.
> 
> 
>> 2) The journal and btree flush issue was not totally fixed in v5.4. If I
>> remember correctly the (currently) final fixes went into mainline kernel
>> in v5.6. Could you please to try v5.6 stable tree see whether the
>> situation might be better.
> 
> I can't move to or really test all that well 5.6.x at this moment.
> However, if you know of a specific patch or set of patches you could
> point me at, I could look at back porting these to 5.4.x for my use.
> 

Here are the following btree flush fixes for your reference,

commit 34cf78bf34d4 ("bcache: fix a lost wake-up problem caused by
mca_cannibalize_lock")
commit 84c529aea182 ("bcache: fix deadlock in bcache_allocator")
commit 9fcc34b1a6dd ("bcache: at least try to shrink 1 node in
bch_mca_scan()")
commit 2aa8c529387c ("bcache: avoid unnecessary btree nodes flushing in
btree_flush_write()")
commit 125d98edd114 ("bcache: remove member accessed from struct btree")
commit d5c9c470b011 ("bcache: reap c->btree_cache_freeable from the tail
in bch_mca_scan()")
commit 5bebf7486d4f ("bcache: fix memory corruption in
bch_cache_accounting_clear()")

Thanks.

Coly Li
