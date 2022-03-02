Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2AFC4C9BB4
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Mar 2022 04:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239203AbiCBDFG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Mar 2022 22:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239199AbiCBDE6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Mar 2022 22:04:58 -0500
X-Greylist: delayed 165 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Mar 2022 19:04:13 PST
Received: from p3plwbeout09-05.prod.phx3.secureserver.net (p3plsmtp09-05-2.prod.phx3.secureserver.net [97.74.135.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484A85F4D7
        for <linux-bcache@vger.kernel.org>; Tue,  1 Mar 2022 19:04:13 -0800 (PST)
Received: from mailex.mailcore.me ([94.136.40.141])
        by :WBEOUT: with ESMTP
        id PFEynu7fnZ22tPFEzn75YD; Tue, 01 Mar 2022 20:01:25 -0700
X-CMAE-Analysis: v=2.4 cv=c55u/Txl c=1 sm=1 tr=0 ts=621ede05
 a=bheWAUFm1xGnSTQFbH9Kqg==:117 a=84ok6UeoqCVsigPHarzEiQ==:17
 a=ggZhUymU-5wA:10 a=IkcTkHD0fZMA:10 a=o8Y5sQTvuykA:10 a=FXvPX3liAAAA:8
 a=lFWsI9-O6uv9ryMHa3YA:9 a=QEXdDO2ut3YA:10 a=SM4aVyO6fsoA:10
 a=OunuuIp3J4_2X_e7vt2U:22 a=fDQtvUcBV1mJc6yKnRhE:22 a=UObqyxdv-6Yh2QiB9mM_:22
X-SECURESERVER-ACCT: phillip@squashfs.org.uk  
X-SID:  PFEynu7fnZ22t
Received: from 82-69-79-175.dsl.in-addr.zen.co.uk ([82.69.79.175] helo=[192.168.178.33])
        by smtp11.mailcore.me with esmtpa (Exim 4.94.2)
        (envelope-from <phillip@squashfs.org.uk>)
        id 1nPFEy-0008Mw-0N; Wed, 02 Mar 2022 03:01:24 +0000
Message-ID: <ac281c26-682c-b8b7-88b2-7e1b4669de5d@squashfs.org.uk>
Date:   Wed, 2 Mar 2022 03:01:20 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/5] squashfs: always use bio_kmalloc in squashfs_bio_read
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20220301084552.880256-1-hch@lst.de>
 <20220301084552.880256-3-hch@lst.de>
From:   Phillip Lougher <phillip@squashfs.org.uk>
In-Reply-To: <20220301084552.880256-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailcore-Auth: 439999529
X-Mailcore-Domain: 1394945
X-123-reg-Authenticated:  phillip@squashfs.org.uk  
X-Originating-IP: 82.69.79.175
X-CMAE-Envelope: MS4xfFRmFqWcrOa+QESdfDK/Hfe89TCLyx+YohBOltXW6TZG+XCmPP0RZQj8GdXgjI0X4ncWQdlz7EVzenD1+ALVB/f3FGv5w/dh6Z/0PW8czFKAwuVY3J9i
 B949qYB+7PoOq9hAkWoc4WyLTIpOTnzm3yeN3+bTeGnts3e+XdqMZYpo0d/bfwRK1joatxDhHeJl0z/LRqFH7DE5Q93hZD+rI8FsYvyVZeHIwGnLiM3QcsGw
 +M3g/3YuCqgb9UwWgkldhw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 01/03/2022 08:45, Christoph Hellwig wrote:
> If a plain kmalloc that is not backed by a mempool is safe here for a
> large read (and the actual page allocations), it must also be for a
> small one, so simplify the code a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Phillip Lougher <phillip@squashfs.org.uk>
