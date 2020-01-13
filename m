Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B88139173
	for <lists+linux-bcache@lfdr.de>; Mon, 13 Jan 2020 13:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgAMM4w (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 13 Jan 2020 07:56:52 -0500
Received: from gw-hh2.hh.nde.ag ([85.183.17.20]:58126 "EHLO mail.nde.ag"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgAMM4w (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Jan 2020 07:56:52 -0500
X-Greylist: delayed 750 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2020 07:56:52 EST
Received: from localhost (localhost [127.0.0.1])
        by mail.nde.ag (Postfix) with ESMTP id 2D6D32A;
        Mon, 13 Jan 2020 13:44:21 +0100 (CET)
X-Virus-Scanned: amavisd-new at hh.nde.ag
Received: from mail.nde.ag ([127.0.0.1])
        by localhost (hh2-mail.hh.nde.ag [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yhxgccmx5cvl; Mon, 13 Jan 2020 13:44:15 +0100 (CET)
Received: from www3.nde.ag (hh2-www.hh.nde.ag [192.168.32.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mail.nde.ag (Postfix) with ESMTPS id 683EB27;
        Mon, 13 Jan 2020 13:44:15 +0100 (CET)
Received: from hh2-www.hh.nde.ag (hh2-www.hh.nde.ag [192.168.32.4]) by
 webmail.nde.ag (Horde Framework) with HTTPS; Mon, 13 Jan 2020 12:44:15 +0000
Date:   Mon, 13 Jan 2020 12:44:15 +0000
Message-ID: <20200113124415.Horde.G9hpYwu_fqvg2w0msexL3ri@webmail.nde.ag>
From:   "Jens-U. Mozdzen" <jmozdzen@nde.ag>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: undo make-bcache (was: Re: Can't mount an encrypted backing device)
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de>
In-Reply-To: <65c05b80-679b-2ccb-1bd1-a9a6887c9c51@suse.de>
User-Agent: Horde Application Framework 5
Accept-Language: de,en
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

jumping in here, because I was looking for a way to revert from bcache  
to plain device:

Zitat von Coly Li <colyli@suse.de>:
> The super block location of the backing disk is occupied by bcache. You
> cannot mount the file system directly from the backing disk which is
> formated as bcache backing device [...] (bcache offset all I/Os on  
> bcache device 4KB behind the requesting
> LBA on backing disk).

Assuming that no caching device is associated with a backing device  
(so the backing device is "clean" as in "containing all data blocks  
with the current content"), could one convert the content of a backing  
device to a "non-bcached device" by removing the first 4096 octets of  
the backing device content?

Something like "dd if=backingdev of=newdev skip_bytes=4096 ..."?

Regards,
J

