Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3421CBA7B
	for <lists+linux-bcache@lfdr.de>; Sat,  9 May 2020 00:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgEHWNs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 18:13:48 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40119 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727787AbgEHWNr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 18:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588976026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7XTZwXR9Z9h3mhkEx2o1bmyDVneFoc2pkGAjVYehhi0=;
        b=RncL95G1n8XUFTaOJapGjDj95acCt1Ym8G7H4dJNG+Pg/r++EnkX0nzb+ThOgN72Me9yXe
        WsaRj8D9yI3Ucsci75A3DbsOc8Js8j4XzsO78PM5KE213nqNF+F2VD3K2sda8Jq6P0cAh7
        ocx771djD+y41WVPdMyFq98Bp9i2vPQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-d2xIQt37O8yux2pmv4ZgAg-1; Fri, 08 May 2020 18:13:42 -0400
X-MC-Unique: d2xIQt37O8yux2pmv4ZgAg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 828A51005510;
        Fri,  8 May 2020 22:13:39 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74FBC1001B07;
        Fri,  8 May 2020 22:13:27 +0000 (UTC)
Date:   Sat, 9 May 2020 06:13:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Geoff Levand <geoff@infradead.org>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org
Subject: Re: remove a few uses of ->queuedata
Message-ID: <20200508221321.GD1389136@T590>
References: <20200508161517.252308-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508161517.252308-1-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, May 08, 2020 at 06:15:02PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> various bio based drivers use queue->queuedata despite already having
> set up disk->private_data, which can be used just as easily.  This
> series cleans them up to only use a single private data pointer.
> 
> blk-mq based drivers that have code pathes that can't easily get at
> the gendisk are unaffected by this series.

Yeah, before adding disk, there still may be requests queued to LLD
for blk-mq based drivers.

So are there this similar situation for these bio based drivers?


Thanks,
Ming

