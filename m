Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF51436FE5
	for <lists+linux-bcache@lfdr.de>; Fri, 22 Oct 2021 04:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhJVCTO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 21 Oct 2021 22:19:14 -0400
Received: from p3plsmtp17-06-2.prod.phx3.secureserver.net ([173.201.193.172]:32940
        "EHLO p3plwbeout17-06.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232428AbhJVCTO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 21 Oct 2021 22:19:14 -0400
Received: from mailex.mailcore.me ([94.136.40.141])
        by :WBEOUT: with ESMTP
        id djzXmNYX6qqZkdjzYmwVes; Thu, 21 Oct 2021 19:09:08 -0700
X-CMAE-Analysis: v=2.4 cv=HYrR8gI8 c=1 sm=1 tr=0 ts=61721d44
 a=bheWAUFm1xGnSTQFbH9Kqg==:117 a=84ok6UeoqCVsigPHarzEiQ==:17
 a=ggZhUymU-5wA:10 a=IkcTkHD0fZMA:10 a=8gfv0ekSlNoA:10 a=JfrnYn6hAAAA:8
 a=qzs_ciw9LVpZ-E7SRj0A:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-SECURESERVER-ACCT: phillip@squashfs.org.uk  
X-SID:  djzXmNYX6qqZk
Received: from 82-69-79-175.dsl.in-addr.zen.co.uk ([82.69.79.175] helo=[192.168.178.33])
        by smtp06.mailcore.me with esmtpa (Exim 4.94.2)
        (envelope-from <phillip@squashfs.org.uk>)
        id 1mdjzW-00029M-HX; Fri, 22 Oct 2021 03:09:07 +0100
Subject: Re: Readahead for compressed data
To:     Phillip Susi <phill@thesusis.net>,
        Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev,
        linux-bcache@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>
References: <YXHK5HrQpJu9oy8w@casper.infradead.org>
 <87tuh9n9w2.fsf@vps.thesusis.net>
From:   Phillip Lougher <phillip@squashfs.org.uk>
Message-ID: <ea03d018-b9ef-9eed-c382-e1a3db7e4e5f@squashfs.org.uk>
Date:   Fri, 22 Oct 2021 03:09:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <87tuh9n9w2.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Mailcore-Auth: 439999529
X-Mailcore-Domain: 1394945
X-123-reg-Authenticated:  phillip@squashfs.org.uk  
X-Originating-IP: 82.69.79.175
X-CMAE-Envelope: MS4xfGFR9RgJxSaQemA4aHbLtJfoROfD/ZBqRlnDER1OlBMwn1sz12sR7xubcD7hNHox5t1Jik28n641+D3CwCZN9YTxYaHIW6Y9YJgOxKG/Fm+md6dS4IbN
 dveA9iIIGUz1Xb0+rSKl0DmkGVAhTx3m/dy1tltfdaLWOExmQatRE3ja0SyDYrRuaHQHUf/9zKe+Rh5hwGBwzWI2MShQkHD/9c5AQUt+K5CY/VbT3bh7qhST
 XG+icDOiMUXA/VvhziuxFQ==
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 22/10/2021 02:04, Phillip Susi wrote:
> 
> Matthew Wilcox <willy@infradead.org> writes:
> 
>> As far as I can tell, the following filesystems support compressed data:
>>
>> bcachefs, btrfs, erofs, ntfs, squashfs, zisofs
>>
>> I'd like to make it easier and more efficient for filesystems to
>> implement compressed data.  There are a lot of approaches in use today,
>> but none of them seem quite right to me.  I'm going to lay out a few
>> design considerations next and then propose a solution.  Feel free to
>> tell me I've got the constraints wrong, or suggest alternative solutions.
>>
>> When we call ->readahead from the VFS, the VFS has decided which pages
>> are going to be the most useful to bring in, but it doesn't know how
>> pages are bundled together into blocks.  As I've learned from talking to
>> Gao Xiang, sometimes the filesystem doesn't know either, so this isn't
>> something we can teach the VFS.
>>
>> We (David) added readahead_expand() recently to let the filesystem
>> opportunistically add pages to the page cache "around" the area requested
>> by the VFS.  That reduces the number of times the filesystem has to
>> decompress the same block.  But it can fail (due to memory allocation
>> failures or pages already being present in the cache).  So filesystems
>> still have to implement some kind of fallback.
> 
> Wouldn't it be better to keep the *compressed* data in the cache and
> decompress it multiple times if needed rather than decompress it once
> and cache the decompressed data?  You would use more CPU time
> decompressing multiple times

There is a fairly obvious problem here.   A malicious attacker could
"trick" the filesystem into endlessly decompressing the same blocks,
which because the compressed data is cached, could cause it to use
all CPU, and cause a DOS attack.  Caching the uncompressed data prevents
these decompression attacks from occurring so easily.

Phillip


