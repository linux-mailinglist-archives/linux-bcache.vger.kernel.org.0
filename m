Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3640B432877
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 22:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhJRUeb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 16:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhJRUeb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 16:34:31 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D981DC06161C;
        Mon, 18 Oct 2021 13:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OBMvbiCZ3mmK4xvpOD56mvuToBpo4s4ONuPdaMpMXso=; b=TIkzxO1O7vQd0T1PMQ31eP873s
        pPHNaKNwfjx7mTwD9RmpK0u2Dr52r7UfxNzSSDXj8Ur4f/57iSBP9syn65/BRLw+Qf0YqEROqC1+F
        /VG4vFcKrZ4lPNCkYzTKj7o2L7DwvWpMe/Cj9lb6MSKQzaI23JMePqdIEZskz+65OByIz865kTj2M
        S7C7JWy6K7A2w9h6miRNVROzQSV0cHn3nsz/ISMK8rBY/sbh7syYv+06of00RqsVQ7L8TnPZCsvnm
        bLR1p6dai2RCCksWMX0lknKUYeC/2U9k2JV7oYNMmdKjgqpOgr1yAHVsYweFfh4DDrfwCTLAV00Ez
        KwZhXR7g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcZIX-00HDlV-C4; Mon, 18 Oct 2021 20:31:53 +0000
Date:   Mon, 18 Oct 2021 13:31:53 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk
Cc:     jejb@linux.ibm.com, agk@redhat.com, snitzer@redhat.com,
        colyli@suse.de, kent.overstreet@gmail.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, roger.pau@citrix.com, geert@linux-m68k.org,
        ulf.hansson@linaro.org, tj@kernel.org, hare@suse.de,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        johannes.berg@intel.com, krisman@collabora.com,
        chris.obbard@collabora.com, thehajime@gmail.com,
        zhuyifei1999@gmail.com, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, miquel.raynal@bootlin.com, vigneshr@ti.com,
        linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, linux-bcache@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-m68k@lists.linux-m68k.org,
        linux-um@lists.infradead.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/9] scsi/sd: add error handling support for add_disk()
Message-ID: <YW3ZuQv1qpIXkd5b@bombadil.infradead.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
 <20211015233028.2167651-2-mcgrof@kernel.org>
 <yq1bl3ofjo5.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1bl3ofjo5.fsf@ca-mkp.ca.oracle.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Sat, Oct 16, 2021 at 10:51:48PM -0400, Martin K. Petersen wrote:
> 
> Luis,
> 
> > We never checked for errors on add_disk() as this function returned
> > void. Now that this is fixed, use the shiny new error handling.
> >
> > As with the error handling for device_add() we follow the same logic
> > and just put the device so that cleanup is done via the
> > scsi_disk_release().
> 
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks, would you like Jens to pick this up and the other scsi/sr patch
or are you taking it through your tree?

  Luis
