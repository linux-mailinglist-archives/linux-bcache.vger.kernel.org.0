Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3332A140138
	for <lists+linux-bcache@lfdr.de>; Fri, 17 Jan 2020 01:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387664AbgAQA7D (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jan 2020 19:59:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:43762 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730151AbgAQA7C (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jan 2020 19:59:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1808CAD5F;
        Fri, 17 Jan 2020 00:59:01 +0000 (UTC)
Subject: Re: undo make-bcache (was: Re: Can't mount an encrypted backing
 device)
To:     clodoaldo.pinto.neto@gmail.com
Cc:     "Jens-U. Mozdzen" <jmozdzen@nde.ag>, linux-bcache@vger.kernel.org
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de>
 <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
 <0c6c3fea-5580-3a71-264c-b383b5b4fe66@suse.de>
 <CA+Z73LGG1pBtT=0WN5vEyqEvzxEnqMRZ26S_2x4Gd5JPSmuXmQ@mail.gmail.com>
 <CA+Z73LFNxP8kDMSq74DBKDbCXpbtMA9svpc1KddkUmrk-cfnOA@mail.gmail.com>
 <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <32fb3244-cb9e-460d-3156-99e418dda44f@suse.de>
Date:   Fri, 17 Jan 2020 08:58:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+Z73LGXJOwYEb+GmPuuDi3TcJbGG=NLv-5vCRcEvB+kgr4a+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/1/17 5:52 上午, Clodoaldo Neto wrote:
> 
> Em seg, 13 de jan de 2020 11:19, Coly Li <colyli@suse.de
> <mailto:colyli@suse.de>> escreveu:
>>
>> On 2020/1/13 8:44 下午, Jens-U. Mozdzen wrote:
>> > Hi Coly,
>> >
>> > jumping in here, because I was looking for a way to revert from bcache
>> > to plain device:
>> >
>> > Zitat von Coly Li <colyli@suse.de <mailto:colyli@suse.de>>:
>> >> The super block location of the backing disk is occupied by bcache. You
>> >> cannot mount the file system directly from the backing disk which is
>> >> formated as bcache backing device [...] (bcache offset all I/Os on
>> >> bcache device 4KB behind the requesting
>> >> LBA on backing disk).
>> >
>> > Assuming that no caching device is associated with a backing device (so
>> > the backing device is "clean" as in "containing all data blocks with the
>> > current content"), could one convert the content of a backing device to
>> > a "non-bcached device" by removing the first 4096 octets of the backing
>> > device content?
>> >
>> > Something like "dd if=backingdev of=newdev skip_bytes=4096 ..."?
>>
>> Hi Jens-U,
>>
>> you may try dmsetup to setup a linear device mapper target, and the map
>> table just skipping the first 4KB (bcache superblock area). If you are
>> lucky, I mean the real file system is not corrupted, the created device
>> mapper target can be mounted directly.
> 
> 
> I'm trying dmsetup but it does not accept anything other than 0 and 0
> at the beginning and end of the table:
> 
> # echo '0 3774578672 linear /dev/mapper/backing-device 8' | dmsetup
> create dmb
> device-mapper: reload ioctl on dmb  failed: Invalid argument
> Command failed.

The above line should work, if 3774578672 is a correct size number in
sectors.

> 
> # echo '8 3774578664 linear /dev/mapper/backing-device 0' | dmsetup
> create dmb
> device-mapper: reload ioctl on dmb  failed: Invalid argument
> Command failed.
> 
> I'm not sure about how it works. Is it not 8 sectors for 4k bytes?
> 

It works on my side, my kernel is Linux v5.5-rc2, lvm2 version is
2.02.180, dmsetup version is 1.02.149. The difference is the device
size, my disk size is much less.

-- 

Coly Li
