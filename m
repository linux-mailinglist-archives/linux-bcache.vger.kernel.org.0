Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA92139387
	for <lists+linux-bcache@lfdr.de>; Mon, 13 Jan 2020 15:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgAMOSb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 13 Jan 2020 09:18:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:38698 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgAMOSb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Jan 2020 09:18:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 192E8ACCA;
        Mon, 13 Jan 2020 14:18:30 +0000 (UTC)
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing
 device)
To:     "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc:     linux-bcache@vger.kernel.org
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de>
 <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <0c6c3fea-5580-3a71-264c-b383b5b4fe66@suse.de>
Date:   Mon, 13 Jan 2020 22:18:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/1/13 8:44 下午, Jens-U. Mozdzen wrote:
> Hi Coly,
> 
> jumping in here, because I was looking for a way to revert from bcache
> to plain device:
> 
> Zitat von Coly Li <colyli@suse.de>:
>> The super block location of the backing disk is occupied by bcache. You
>> cannot mount the file system directly from the backing disk which is
>> formated as bcache backing device [...] (bcache offset all I/Os on
>> bcache device 4KB behind the requesting
>> LBA on backing disk).
> 
> Assuming that no caching device is associated with a backing device (so
> the backing device is "clean" as in "containing all data blocks with the
> current content"), could one convert the content of a backing device to
> a "non-bcached device" by removing the first 4096 octets of the backing
> device content?
> 
> Something like "dd if=backingdev of=newdev skip_bytes=4096 ..."?

Hi Jens-U,

you may try dmsetup to setup a linear device mapper target, and the map
table just skipping the first 4KB (bcache superblock area). If you are
lucky, I mean the real file system is not corrupted, the created device
mapper target can be mounted directly.


-- 

Coly Li
