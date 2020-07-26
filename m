Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9473022E061
	for <lists+linux-bcache@lfdr.de>; Sun, 26 Jul 2020 17:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgGZPHu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 26 Jul 2020 11:07:50 -0400
Received: from verein.lst.de ([213.95.11.211]:40627 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725982AbgGZPHu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 26 Jul 2020 11:07:50 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D730768B05; Sun, 26 Jul 2020 17:07:47 +0200 (CEST)
Date:   Sun, 26 Jul 2020 17:07:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     sagi@grimberg.me, philipp.reisner@linbit.com,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org, hch@lst.de,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Jan Kara <jack@suse.com>,
        Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Vlastimil Babka <vbabka@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] nvme-tcp: use sendpage_ok() to check page for
 kernel_sendpage()
Message-ID: <20200726150747.GB23338@lst.de>
References: <20200726135224.107516-1-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200726135224.107516-1-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The sendpage_ok helper should go into a separate patch and probably
be an inline fuction.  Also please add the netdev list to the Cc list.
